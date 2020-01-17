//
//  File.swift
//  
//
//  Created by Kevin Le Goff on 14/01/2020.
//

import Foundation


/// Represent a Quote with the text of the quote
/// and its author and an id
public struct Quote: Decodable {

    /// The quote id
    public let id: Int

    /// The author of the quote
    public let author: String

    /// The quote text
    public let quote: String

    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case author
        case quote
    }
}
