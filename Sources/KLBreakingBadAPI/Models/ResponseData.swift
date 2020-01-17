//
//  File.swift
//  
//
//  Created by Kevin Le Goff on 13/01/2020.
//

import Foundation


/**
 ResponseData<T> data encapsulate response from server
 and potential error received.
 Usually when a error is received the data is nil
*/
public struct ResponseData<T: Decodable> {

    /// Data returned by the server, can be nil in case of error
    public let data: T?

    /// Error is populated in case something wrong occur while trying to retreive the data
    public let error: Error?
}

// Factory methods for creating ResponseDataInstances
extension ResponseData {

    static func error(_ error: Error) -> ResponseData {
        return ResponseData(data: nil, error: error)
    }

    static func success(_ data: T) -> ResponseData {
        return ResponseData(data: data, error: nil)
    }
}
