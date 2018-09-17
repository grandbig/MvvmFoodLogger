//
//  PlacesViewModelTests.swift
//  MvvmFoodLoggerTests
//
//  Created by Takahiro Kato on 2018/09/16.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import GoogleMaps
@testable import MvvmFoodLogger

class PlacesViewModelTests: XCTestCase {

    /// テスト用のモックGooglePlacesAPIClient
    final class MockGooglePlacesAPIClient: GooglePlacesAPIClient {

        func fetchRestaurants(coordinate: CLLocationCoordinate2D) -> Observable<Result<Places>> {
            return Observable.just(mockPlacesItem())
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
    static let mockPlacesItem = { () -> Result<Places> in
        let location = Location(lat: 35.0, lng: 137.0)
        let viewport = Viewport(northeast: location, southwest: location)
        let geometry = Geometry(viewport: viewport, location: location)
        let place = Place(id: "", placeId: "", name: "", icon: "", rating: nil, scope: "", vicinity: "", reference: "",
                          priceLevel: nil, types: [], geometry: geometry, openingHours: nil, photos: nil)
        let places = Places(results: [place], status: R.string.common.ok(), htmlAttributions: [])
        let result = Result.success(places)
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
    
    func testUpdateLocation() {
        let disposeBag = DisposeBag()
        let camera = scheduler.createObserver(GMSCameraPosition?.self)

        viewModel.camera
            .bind(to: camera)
            .disposed(by: disposeBag)

        scheduler.scheduleAt(5) { [unowned self] in
            self.viewModel.updateLocation.onNext(())
        }

        scheduler.start()

        let mockCamera: GMSCameraPosition? = GMSCameraPosition.camera(withLatitude: PlacesViewModelTests.mockLocation().latitude,
                                                                      longitude: PlacesViewModelTests.mockLocation().longitude,
                                                                      zoom: 16.0)
        let expectedItems = [
            next(0, nil),
            next(5, mockCamera)
        ]

        for (key, event) in camera.events.enumerated() {
            XCTAssertEqual(event.value.element.unsafelyUnwrapped?.target.latitude,
                           expectedItems[key].value.element.unsafelyUnwrapped?.target.latitude)
            XCTAssertEqual(event.value.element.unsafelyUnwrapped?.target.longitude,
                           expectedItems[key].value.element.unsafelyUnwrapped?.target.longitude)
        }
    }

    func testSearch() {
        let disposeBag = DisposeBag()
        let places = scheduler.createObserver(Places.self)
        viewModel.places
            .bind(to: places)
            .disposed(by: disposeBag)

        scheduler.scheduleAt(5) { [unowned self] in
            self.viewModel.searchButtonDidTap.onNext(())
        }

        scheduler.start()
        let expectedItems = next(5, PlacesViewModelTests.mockPlacesItem())
        if case let .success(value)? = expectedItems.value.element {
            XCTAssertEqual(places.events[1].value.element?.results, value.results)
        }
    }
}
