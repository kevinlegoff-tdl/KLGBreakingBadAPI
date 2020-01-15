//
//  File.swift
//  
//
//  Created by Kevin Le Goff on 13/01/2020.
//

public struct Character: Codable {
    public let id: Int
    public let name: String

    enum CodingKeys: String, CodingKey {
           case id = "char_id"
           case name
       }
}
