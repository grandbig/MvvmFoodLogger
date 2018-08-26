//
//  PlacesViewModel.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/08/26.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import RxSwift

final class PlacesViewModel {
    private let disposeBag = DisposeBag()

    private let viewWillAppearStream = PublishSubject<Void>()
    private let placeMarkerDidTapStream = PublishSubject<Void>()
    private let placesStream = BehaviorSubject<[Place]>(value: [])
    private let navigateToPlaceStream = PublishSubject<Void>()
}

// MARK: Input
extension PlacesViewModel {
    var viewWillAppear: AnyObserver<Void> {
        return viewWillAppearStream.asObserver()
    }

    var placeMarkerDidTap: AnyObserver<Void> {
        return placeMarkerDidTapStream.asObserver()
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
