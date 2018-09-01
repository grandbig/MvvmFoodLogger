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
    private var initedView: Bool = false
    
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

        bind()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bind() {
        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
            .flatMapLatest({ _ -> Observable<()> in
                return Observable.just(())
            })
            .bind(to: viewModel.updateLocation)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .bind(to: viewModel.searchButtonDidTap)
            .disposed(by: disposeBag)

        viewModel.camera
            .bind { [weak self] camera in
                guard let strongSelf = self, let camera = camera else { return }
                if !strongSelf.initedView {
                    strongSelf.mapView.camera = camera
                    strongSelf.initedView = true
                }                
            }
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
