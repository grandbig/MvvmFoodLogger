//
//  PlacesViewModel.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/08/26.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

final class PlacesViewModel: Injectable {

    struct Dependency {
        let apiClient: GooglePlacesAPIClient
        let locationManager: LocationManager
        let coordinate: CLLocationCoordinate2D
    }
    private let disposeBag = DisposeBag()

    // MARK: PublishSubjects
    private let updateLocationStream = PublishSubject<Void>()
    private let searchButtonDidTapStream = PublishSubject<Void>()
    private let markerDidTapStream = PublishSubject<String>()
    private let navigateToPlaceStream = PublishSubject<Void>()

    // MARK: BehaviorSubjects
    private let cameraStream = BehaviorSubject<GMSCameraPosition?>(value: nil)
    private let placesStream = BehaviorSubject<Places>(value: Places(results: [], status: "0", htmlAttributions: []))
    private let imageStream = BehaviorSubject<UIImage?>(value: nil)

    // MARK: initial method
    init(with dependency: Dependency) {
        let apiClient = dependency.apiClient
        let locationManager = dependency.locationManager
        var coordinate = dependency.coordinate

        updateLocationStream
            .flatMapLatest { _ -> Observable<CLLocationCoordinate2D?> in
                return locationManager.fetchCurrentLocation()
            }.flatMapLatest({ (location) -> Observable<GMSCameraPosition?> in
                guard let location = location else {
                    return Observable.just(nil)
                }
                coordinate = location
                let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                                      longitude: location.longitude,
                                                      zoom: 16.0)
                return Observable.just(camera)
            })
            .bind(to: cameraStream)
            .disposed(by: disposeBag)

        searchButtonDidTapStream
            .flatMapLatest { _ -> Observable<Places> in
                return apiClient.fetchRestaurants(coordinate: coordinate)
            }
            .bind(to: placesStream)
            .disposed(by: disposeBag)

        markerDidTapStream
            .flatMapLatest { placeId -> Observable<UIImage?> in
                return apiClient.fetchPhoto(placeId: placeId)
            }
            .bind(to: imageStream)
            .disposed(by: disposeBag)
    }
}

// MARK: Input
extension PlacesViewModel {
    var updateLocation: AnyObserver<()> {
        return updateLocationStream.asObserver()
    }

    var searchButtonDidTap: AnyObserver<()> {
        return searchButtonDidTapStream.asObserver()
    }

    var markerDidTap: AnyObserver<String> {
        return markerDidTapStream.asObserver()
    }
}

// MARK: Output
extension PlacesViewModel {
    var places: Observable<Places> {
        return placesStream.asObservable()
    }

    var camera: Observable<GMSCameraPosition?> {
        return cameraStream.asObservable()
    }

    var image: Observable<UIImage?> {
        return imageStream.asObservable()
    }

    var navigateToPlace: Observable<Void> {
        return navigateToPlaceStream.asObservable()
    }
}
