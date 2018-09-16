//
//  MvvmFoodLoggerTests.swift
//  MvvmFoodLoggerTests
//
//  Created by Takahiro Kato on 2018/08/26.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import XCTest
import RxSwift
import CoreLocation
@testable import MvvmFoodLogger

protocol APIClient {
    func fetchRestaurants(coordinate: CLLocationCoordinate2D) -> Places
}

class MockAPIClient: APIClient {

    func fetchRestaurants(coordinate: CLLocationCoordinate2D) -> Places {
        let location = Location(lat: 35.0, lng: 137.0)
        let viewport = Viewport(northeast: location, southwest: location)
        let geometry = Geometry(viewport: viewport, location: location)
        let place = Place(id: "", placeId: "", name: "", icon: "", rating: nil, scope: "", vicinity: "", reference: "",
                          priceLevel: nil, types: [], geometry: geometry, openingHours: nil, photos: nil)
        let places = Places(results: [place], status: R.string.common.ok(), htmlAttributions: [])
        return places
    }

    func fetchPhoto(placeId: String) -> Observable<UIImage?> {
        return Observable.just(nil)
    }
}

class ViewController: UIViewController, Injectable {
    typealias Dependency = APIClient
    private let apiClient: APIClient
    private let disposeBag = DisposeBag()
    
    var places: [Place] = []
    
    required init(with dependency: Dependency) {
        apiClient = dependency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func request() {
        let coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        places = apiClient.fetchRestaurants(coordinate: coordinate).results
    }
}

class DIMockTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRequest() {
        let apiClient = MockAPIClient()
        let vc = ViewController(with: apiClient)

        let location = Location(lat: 35.0, lng: 137.0)
        let viewport = Viewport(northeast: location, southwest: location)
        let geometry = Geometry(viewport: viewport, location: location)
        let place = Place(id: "", placeId: "", name: "", icon: "", rating: nil, scope: "", vicinity: "", reference: "",
                          priceLevel: nil, types: [], geometry: geometry, openingHours: nil, photos: nil)

        XCTAssertTrue(vc.places.isEmpty)
        vc.request()
        XCTAssertEqual(vc.places, [place])
    }
}
