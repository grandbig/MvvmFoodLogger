//
//  Result.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/09/16.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

enum Result<T> {
    case success(T)
    case failure(error: Error)
}
