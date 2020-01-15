//
//  File.swift
//  
//
//  Created by Kevin Le Goff on 13/01/2020.
//

import Foundation
import XCTest
@testable import KLBreakingBadAPI

final class KLBreakingBadAPIDataTests: XCTestCase {

    func testCanParseSingleCharacter() {
        do {
             let walter = try JSONDecoder().decode(
                Character.self,
                from: TestData.WalterWhite.data(using: .utf8)!)
                XCTAssertEqual(walter.id, 1)
                XCTAssertEqual(walter.name, "Walter White")
        } catch {
                XCTFail("Unexpected error while decoding JSON for character \(error)")
        }
    }

    func testCanParseSingleQuote() {
        do {
             let quote = try JSONDecoder().decode(
                Quote.self,
                from: singleQuote.data(using: .utf8)!)
                XCTAssertEqual(quote.id, 1)
                XCTAssertEqual(quote.author, "Walter White")
                XCTAssertEqual(quote.quote, "I am not in danger, Skyler. I am the danger!")
        } catch {
                XCTFail("Unexpected error while decoding JSON for character \(error)")
        }
    }


    static var allTests = [
        ("testCanParseSingleCharacter", testCanParseSingleCharacter),
    ]
}
