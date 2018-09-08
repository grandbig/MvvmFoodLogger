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
    private let addFavoriteButtonDidTapStream = PublishSubject<String>()
    private let navigateToPlaceStream = PublishSubject<Void>()

    // MARK: BehaviorSubjects
    private let cameraStream = BehaviorSubject<GMSCameraPosition?>(value: nil)
    private let placesStream = BehaviorSubject<[Place]>(value: [])
    private let imageStream = BehaviorSubject<UIImage?>(value: nil)
    private let resultOfAddFavoriteStream = BehaviorSubject<Bool>(value: true)

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
            .flatMapLatest { _ -> Observable<[Place]> in
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

        addFavoriteButtonDidTapStream
            .flatMapLatest { placeId -> Observable<Bool> in
                // TODO: Realmに保存する処理を実装
                return Observable.just(true)
            }
            .bind(to: resultOfAddFavoriteStream)
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

    var addFavoriteButtonDidTap: AnyObserver<String> {
        return addFavoriteButtonDidTapStream.asObserver()
    }
}

// MARK: Output
extension PlacesViewModel {
    var places: Observable<[Place]> {
        return placesStream.asObservable()
    }

    var camera: Observable<GMSCameraPosition?> {
        return cameraStream.asObservable()
    }

    var image: Observable<UIImage?> {
        return imageStream.asObservable()
    }

    var resultOfAddFavorite: Observable<Bool> {
        return resultOfAddFavoriteStream.asObservable()
    }

    var navigateToPlace: Observable<Void> {
        return navigateToPlaceStream.asObservable()
    }
}
