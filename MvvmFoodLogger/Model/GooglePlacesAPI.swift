//
//  GooglePlacesAPI.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/08/26.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import PromiseKit
import GooglePlaces

internal enum GooglePlacesAPITarget {
    case restaurants(lat: Double, lng: Double)
}

internal enum APIError: Error {
    case cancel
    case apiError(description: String)
    case decodeError
}

internal enum GooglePlacesError: Error {
    case cancel
    case notFoundError
}

protocol GooglePlacesAPIClient {

    func fetchRestaurants(lat: Double, lng: Double) -> Observable<[Place]>
    func fetchPhoto(placeId: String) -> Promise<UIImage?>
}

extension GooglePlacesAPITarget: TargetType {
    
    /// API Key
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: R.string.common.keyFileName(),
                                          ofType: R.string.common.plistExtension()) else {
                                            fatalError("key.plistが見つかりません")
        }
        
        guard let dic = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("key.plistの中身が想定通りではありません")
        }
        
        guard let apiKey = dic[R.string.common.googleApiKeyName()] as? String else {
            fatalError("Google APIのKeyが設定されていません")
        }
        
        return apiKey
    }
    
    // ベースURLを文字列で定義
    private var _baseURL: String {
        switch self {
        case .restaurants:
            return R.string.url.googlePlacesApiPlaceUrl()
        }
        
    }
    
    public var baseURL: URL {
        return URL(string: _baseURL)!
    }
    
    // enumの値に対応したパスを指定
    public var path: String {
        switch self {
        case .restaurants:
            return ""
        }
    }
    
    // enumの値に対応したHTTPメソッドを指定
    public var method: Moya.Method {
        switch self {
        case .restaurants:
            return .get
        }
    }
    
    // スタブデータの設定
    public var sampleData: Data {
        switch self {
        case .restaurants:
            return "Stub data".data(using: String.Encoding.utf8)!
        }
    }
    
    // パラメータの設定
    var task: Task {
        switch self {
        case let .restaurants(lat, lng):
            return .requestParameters(parameters: [
                R.string.common.keyFileName(): apiKey,
                R.string.common.locationKeyName(): "\(lat),\(lng)",
                R.string.common.radiusKeyName(): 1500,
                R.string.common.typeKeyName(): R.string.common.restaurantTypeValueName()
                ], encoding: URLEncoding.default)
        }
    }
    
    // ヘッダーの設定
    var headers: [String: String]? {
        switch self {
        case .restaurants:
            return nil
        }
    }
}

class GooglePlacesAPI: GooglePlacesAPIClient {
    private let disposeBag = DisposeBag()
    private var provider: MoyaProvider<GooglePlacesAPITarget>!
    
    /// イニシャライザ
    init() {
        provider = MoyaProvider<GooglePlacesAPITarget>()
    }
    
    // MARK: CRUD operations
    
    /// 指定の緯度、経度から一定範囲内のレストランを検索する処理
    ///
    /// - Returns: レストランのプレイス情報
    func fetchRestaurants(lat: Double, lng: Double) -> Observable<[Place]> {
        
        return provider.rx
            .request(.restaurants(lat: lat, lng: lng))
            .filterSuccessfulStatusCodes()
            .map(Places.self)
            .map({ places -> [Place] in
                return places.results
            })
            .asObservable()
    }
    
    func fetchPhoto(placeId: String) -> Promise<UIImage?> {
        let (promise, resolver) = Promise<UIImage?>.pending()
        
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeId) { (photos, error) in
            if let error = error {
                resolver.reject(error)
                return
            }
            guard let firstPhoto = photos?.results.first else {
                resolver.reject(GooglePlacesError.notFoundError)
                return
            }
            GMSPlacesClient.shared().loadPlacePhoto(firstPhoto, callback: { (image, error) in
                if let error = error {
                    resolver.reject(error)
                    return
                }
                resolver.fulfill(image)
            })
        }
        
        return promise
    }
}
