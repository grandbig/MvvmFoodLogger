//
//  LocationManager.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/09/01.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

protocol LocationManagerClient {
    func fetchCurrentLocation() -> Observable<CLLocationCoordinate2D?>
}

protocol LocationManagerDelegate: class {
    func didUpdateLatestLocation(location: CLLocationCoordinate2D?)
}

final class LocationManager: NSObject, LocationManagerClient {

    private var manager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D?
    private let defaultLatitude = 0.0
    private let defaultLongitude = 0.0
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()

        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        manager?.delegate = self
    }

    func fetchCurrentLocation() -> Observable<CLLocationCoordinate2D?> {
        return Observable.just(currentLocation)
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
        delegate?.didUpdateLatestLocation(location: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if !CLLocationManager.locationServicesEnabled() {
            // 端末の位置情報がOFFになっている場合
            currentLocation = nil
            return
        }
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse {
            // アプリの位置情報許可をOFFにしている場合
            return
        }
    }
}
