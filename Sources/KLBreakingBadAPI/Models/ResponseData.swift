//
//  File.swift
//  
//
//  Created by Kevin Le Goff on 13/01/2020.
//

import Foundation

struct ResponseData<T: Decodable> {
    let data: T?
    let error: Error?
}

// Simple factory methods for the ResponseData method
extension ResponseData {

    static func error(_ error: Error) -> ResponseData {
        return ResponseData(data: nil, error: error)
    }

    static func success(_ data: T) -> ResponseData {
        return ResponseData(data: data, error: nil)
    }
}
