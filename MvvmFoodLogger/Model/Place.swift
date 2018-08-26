//
//  Place.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/08/26.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation

public struct Location: Codable {
    
    public var lat: Double
    public var lng: Double
}

public struct Viewport: Codable {
    
    public var northeast: Location
    public var southwest: Location
}

public struct Geometry: Codable {
    
    public var viewport: Viewport
    public var location: Location
}

public struct OpeningHours: Codable {
    
    public var weekdayText: [String]?
    public var openNow: Bool
}

public struct Photos: Codable {
    
    public var photoReference: String
    public var width: Double
    public var height: Double
    public var htmlAttributions: [String]
}

public struct Place: Codable {
    
    public var id: String
    public var placeId: String
    public var name: String
    public var icon: String
    public var rating: Double?
    public var scope: String
    public var vicinity: String
    public var reference: String
    public var priceLevel: Int?
    public var types: [String]
    public var geometry: Geometry
    public var openingHours: OpeningHours?
    public var photos: [Photos]?
}
