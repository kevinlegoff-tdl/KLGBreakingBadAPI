//
//  File.swift
//  
//
//  Created by Kevin Le Goff on 14/01/2020.
//

import Foundation

public struct Quote: Decodable {

    public let id: Int
    public let author: String
    public let quote: String

    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case author
        case quote
    }
}
