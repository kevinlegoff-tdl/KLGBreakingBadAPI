//
//  KLBreakingBadAPIProdSanityCheck.swift
//  
//
//  Created by Kevin Le Goff on 15/01/2020.
//

import XCTest
@testable import KLBreakingBadAPI

final class KLBreakingBadAPIProdSanityCheck: XCTestCase {

    var apiClient: BreakingBadApiClient!

    override func setUp() {
        apiClient =  BreakingBadRestApiClient()
    }

    func testGetAllChararctersFromProdServer() {
        let dataLoadedExpectation = XCTestExpectation(description: "Wait for the data to arrive")
        apiClient.allTVCharacters { response in
            guard let data = response.data else {
                XCTFail("The data should not be nil")
                return
            }
            XCTAssert(data.count > 1, "There should be at least one characters on prod but \(data.count) is returned")
            dataLoadedExpectation.fulfill()
        }
        wait(for: [dataLoadedExpectation], timeout: 10.0)
    }

    func testCanGetRandomQuoteFromProd() {
        let apiClient = BreakingBadRestApiClient()
        let firstQuoteExpectation = XCTestExpectation(description: "Wait for first quote to be retreived")
        let secondQuoteExpectation = XCTestExpectation(description: "Waiting for second quot to be retreived")

        var firstQuote, secondQuote : Quote?
        apiClient.randomQuote { response in
            guard let data = response.data else {
                XCTFail("The data should not be nil but we got error \(String(describing: response.error))")
                return
            }
            firstQuote = data
            firstQuoteExpectation.fulfill()
        }

        apiClient.randomQuote { response in
            guard let data = response.data else {
                XCTFail("The data should not be nil")
                return
            }
            secondQuote = data
            secondQuoteExpectation.fulfill()
        }
        wait(for: [firstQuoteExpectation, secondQuoteExpectation], timeout: 10.0)
        XCTAssertNotNil(firstQuote, "First Quote is nil")
        XCTAssertNotNil(secondQuote, "Seconde Quote is nil")
        XCTAssertNotEqual(firstQuote?.id, secondQuote?.id)
    }

    static var allTests = [
        ("testCanGetRandomQuoteFromProd", testCanGetRandomQuoteFromProd),
        ("testGetAllChararctersFromProdServer", testGetAllChararctersFromProdServer)
    ]
}
