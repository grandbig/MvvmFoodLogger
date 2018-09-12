//
//  Place.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/08/26.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation

public struct Location: Codable, Equatable {
    
    public var lat: Double
    public var lng: Double
}

public struct Viewport: Codable, Equatable {
    
    public var northeast: Location
    public var southwest: Location
}

public struct Geometry: Codable, Equatable {
    
    public var viewport: Viewport
    public var location: Location
}

public struct OpeningHours: Codable, Equatable {
    
    public var weekdayText: [String]?
    public var openNow: Bool
}

public struct Photos: Codable, Equatable {
    
    public var photoReference: String
    public var width: Double
    public var height: Double
    public var htmlAttributions: [String]
}

public struct Place: Codable, Equatable {
    public static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
            && lhs.placeId == rhs.placeId
            && lhs.name == rhs.name
            && lhs.icon == rhs.icon
            && lhs.rating == rhs.rating
            && lhs.scope == rhs.scope
            && lhs.vicinity == rhs.vicinity
            && lhs.reference == rhs.reference
            && lhs.priceLevel == rhs.priceLevel
            && lhs.types == rhs.types
            && lhs.geometry == rhs.geometry
            && lhs.openingHours == rhs.openingHours
            && lhs.photos == rhs.photos
    }

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
