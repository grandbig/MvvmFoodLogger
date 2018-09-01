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

final class PlacesViewModel: Injectable {

    struct Dependency {
        let apiClient: GooglePlacesAPIClient
        let lat: Double
        let lng: Double
    }
    private let disposeBag = DisposeBag()

    private let viewWillAppearStream = PublishSubject<Void>()
    private let searchButtonDidTapStream = PublishSubject<Void>()
    private let placesStream = BehaviorSubject<[Place]>(value: [])
    private let navigateToPlaceStream = PublishSubject<Void>()

    init(with dependency: Dependency) {
        let apiClient = dependency.apiClient
        let lat = dependency.lat
        let lng = dependency.lng
        searchButtonDidTapStream
            .flatMapLatest { _ -> Observable<[Place]> in
                return apiClient.fetchRestaurants(lat: lat, lng: lng)
            }
            .bind(to: placesStream)
            .disposed(by: disposeBag)
    }
}

// MARK: Input
extension PlacesViewModel {
    var viewWillAppear: AnyObserver<()> {
        return viewWillAppearStream.asObserver()
    }

    var searchButtonDidTap: AnyObserver<()> {
        return searchButtonDidTapStream.asObserver()
    }
}

// MARK: Output
extension PlacesViewModel {
    var places: Observable<[Place]> {
        return placesStream.asObservable()
    }

    var navigateToPlace: Observable<Void> {
        return navigateToPlaceStream.asObservable()
    }
}
