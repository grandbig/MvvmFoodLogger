//
//  RestaurantMarker.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/09/05.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import GoogleMaps

final class RestaurantMarker: GMSMarker {

    public var id: String!
    public var name: String!

    override init() {
        super.init()
    }
}
