//
//  PlacesViewModelErrorTests.swift
//  MvvmFoodLoggerTests
//
//  Created by Takahiro Kato on 2018/09/29.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import GoogleMaps
@testable import MvvmFoodLogger

class PlacesViewModelErrorTests: XCTestCase {

    /// テスト用のモックGooglePlacesAPIClient
    final class MockGooglePlacesAPIClient: GooglePlacesAPIClient {
        
        func fetchRestaurants(coordinate: CLLocationCoordinate2D) -> Observable<Result<Places>> {
            return Observable.just(mockPlacesErrorItem())
        }
        
        func fetchPhoto(placeId: String) -> Observable<UIImage?> {
            return Observable.just(R.image.noImage())
        }
    }

    /// テスト用のモックLocationManagerClient
    final class MockLocationManagerClient: LocationManagerClient {
        func fetchCurrentLocation() -> Observable<CLLocationCoordinate2D?> {
            return Observable.just(mockLocation())
        }
    }

    /// テスト用のモックPlacesデータ
    static let mockPlacesErrorItem = { () -> Result<Places> in
        let result = Result<Places>.failure(error: APIError.apiError(description: "Error"))
        return result
    }

    /// テスト用のモック位置情報データ
    static let mockLocation = { () -> CLLocationCoordinate2D in
        return CLLocationCoordinate2D(latitude: 35.0, longitude: 137.0)
    }

    var viewModel: PlacesViewModel!
    let scheduler = TestScheduler(initialClock: 0)

    override func setUp() {
        super.setUp()
        let dependency = PlacesViewModel.Dependency(apiClient: MockGooglePlacesAPIClient(),
                                                    locationManager: MockLocationManagerClient(),
                                                    coordinate: PlacesViewModelTests.mockLocation())
        viewModel = PlacesViewModel(with: dependency)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testSearchError() {
        let disposeBag = DisposeBag()
        let places = scheduler.createObserver(Places.self)
        viewModel.places
            .bind(to: places)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(5) { [unowned self] in
            self.viewModel.searchButtonDidTap.onNext(())
        }
        
        scheduler.start()
        let expectedItems = next(5, PlacesViewModelErrorTests.mockPlacesErrorItem())
        if case let .success(value)? = expectedItems.value.element {
            XCTAssertEqual(places.events[1].value.element?.results, value.results)
        }
    }

}
