//
//  URL+QueryItem.swift
//  
//
//  Created by Kevin Le Goff on 14/01/2020.
//
import Foundation

extension URL {

    func appendingQuery(key: String, value: String) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: key, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
