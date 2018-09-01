//
//  PlacesViewController.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/09/01.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps

class PlacesViewController: UIViewController, Injectable {
    
    typealias Dependency = PlacesViewModel
    
    // MARK: - IBOutlets
    @IBOutlet weak private var mapView: GMSMapView!
    @IBOutlet weak private var searchButton: UIButton!
    
    // MARK: - Properties
    private let viewModel: PlacesViewModel
    private var dataSource = [Place]()
    private let disposeBag = DisposeBag()
    private var locationManager: CLLocationManager?
    private let zoomLevel: Float = 16.0
    private var currentLocation: CLLocationCoordinate2D?
    private var initView: Bool = false
    
    required init(with dependency: Dependency) {
        viewModel = dependency
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // GoogleMapの初期化
        mapView.isMyLocationEnabled = true
        mapView.mapType = GMSMapViewType.normal
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.delegate = self
        
        // 位置情報関連の初期化
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bind() {
        searchButton.rx.tap
            .bind(to: viewModel.searchButtonDidTap)
            .disposed(by: disposeBag)
        viewModel.places
            .bind { [weak self] places in
                guard let strongSelf = self else { return }
                places.forEach({ (place) in
                    strongSelf.putMarker(place: place)
                })
            }
            .disposed(by: disposeBag)
    }
    
    private func putMarker(place: Place) {
        let coordinate = CLLocationCoordinate2D(latitude: place.geometry.location.lat, longitude: place.geometry.location.lng)
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
}

// MARK: - GMSMapViewDelegate
extension PlacesViewController: GMSMapViewDelegate {
}

// MARK: - CLLocationManagerDelegate
extension PlacesViewController: CLLocationManagerDelegate {
    
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
        // 現在地の更新
        currentLocation = locations.last?.coordinate
        
        if !initView {
            // 初期描画時のマップ中心位置の移動
            let camera = GMSCameraPosition.camera(withTarget: currentLocation!, zoom: zoomLevel)
            mapView.camera = camera
            initView = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if !CLLocationManager.locationServicesEnabled() {
            // 端末の位置情報がOFFになっている場合
            // アラートはデフォルトで表示されるので内部で用意はしない
            self.currentLocation = nil
            return
        }
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse {
            // アプリの位置情報許可をOFFにしている場合
            return
        }
    }
}
