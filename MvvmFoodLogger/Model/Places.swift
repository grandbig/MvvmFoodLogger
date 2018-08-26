//
//  Places.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/08/26.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation

public struct Places: Codable {
    
    public var results: [Place]
    public var status: String
    public var htmlAttributions: [String]
}
