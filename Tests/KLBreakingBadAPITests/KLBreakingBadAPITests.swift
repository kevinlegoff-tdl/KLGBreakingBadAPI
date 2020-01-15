import XCTest
@testable import KLBreakingBadAPI

final class KLBreakingBadAPITests: XCTestCase {

    var testURLSession: URLSession!

    override func setUp() {
        let urlForAllCharacters = URL(string: "https://www.breakingbadapi.com/api/characters")
        let urlForRandomQuote = URL(string: "https://www.breakingbadapi.com/api/quote/random")
        let urlForWalterWaiteRandomQuote = URL(string: "https://www.breakingbadapi.com/api/quote/random?author=Walter%20White")

        URLProtocolMock.testURLs = [
            urlForAllCharacters: Data(AllCharactersTestData.utf8),
            urlForRandomQuote: Data(randomQuoteTestData.utf8),
            urlForWalterWaiteRandomQuote: Data(randomQuoteTestData.utf8)
        ]

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        testURLSession = URLSession(configuration: config)
    }

    func testAllCharactersEndpointDefinition() {
        let apiClient = BreakingBadRestApiClient()
        let expextedForCharacters =  URL(string: "https://www.breakingbadapi.com/api/characters")!
        XCTAssertEqual(expextedForCharacters, apiClient.allCharactersEndoint)
    }

    func testRandomQuoteEndpointDefinition() {
        let apiClient = BreakingBadRestApiClient()
        let expextedForCharacters =  URL(string: "https://www.breakingbadapi.com/api/quote/random")!
        XCTAssertEqual(expextedForCharacters, apiClient.randomQuoteEndpoint)
    }

    func testRandomQuoteForCharacterEndpointDefinition() {
        let apiClient: BreakingBadApiClient = BreakingBadRestApiClient()
        let result = apiClient.buildQuoteFromCharacterURL(name: "Jesse Pinkman")
        XCTAssertEqual(result.absoluteString, "https://www.breakingbadapi.com/api/quote/random?author=Jesse%20Pinkman")
    }

    func testCanGetDataForAllCharacters() {
        let apiClient = BreakingBadRestApiClient()
        let dataLoadedExpectation = XCTestExpectation(description: "Wait for the data to arrive")

        apiClient.allTVCharacters(using: testURLSession) { response in
            guard let data = response.data else {
                XCTFail("The data should not be nil")
                return
            }
            XCTAssertEqual(data.count, 63)
            XCTAssertEqual(data.first!.name, "Walter White")
            XCTAssertEqual(data.first!.id, 1)
            dataLoadedExpectation.fulfill()
        }
        wait(for: [dataLoadedExpectation], timeout: 10.0)
    }

    func testCanGetRandomQuote() {
        let apiClient = BreakingBadRestApiClient()
        let firstQuoteExpectation = XCTestExpectation(description: "Wait for first quote to be retreived")
        var firstQuote : Quote?
        apiClient.randomQuote(using: testURLSession) { response in
            guard let data = response.data else {
                XCTFail("The data should not be nil")
                return
            }
            firstQuote = data
            firstQuoteExpectation.fulfill()
        }
        wait(for: [firstQuoteExpectation], timeout: 10.0)
        XCTAssertNotNil(firstQuote, "First Quote is nil")
    }

    func testGetWalterWaiteRandomQuote() {
        let apiClient = BreakingBadRestApiClient()
        let firstQuoteExpectation = XCTestExpectation(description: "Wait for first quote to be retreived")
        var firstQuote : Quote?
        apiClient.randomQuote(using: testURLSession, fromCharacterWithName: "Walter White") { response in
            guard let data = response.data else {
                XCTFail("The data should not be nil")
                return
            }
            firstQuote = data
            firstQuoteExpectation.fulfill()
        }
        wait(for: [firstQuoteExpectation], timeout: 10.0)
        XCTAssertNotNil(firstQuote, "First Quote is nil")
        XCTAssertEqual(firstQuote?.author, "Walter White")
    }

    static var allTests = [
        ("testAllCharactersEndpointDefinition", testAllCharactersEndpointDefinition),
        ("testRandomQuoteEndpointDefinition", testRandomQuoteEndpointDefinition),
        ("testRandomQuoteForCharacterEndpointDefinition", testRandomQuoteForCharacterEndpointDefinition),
        ("testCanGetDataForAllCharacters", testCanGetDataForAllCharacters),
        ("testGetWalterWaiteRandomQuote", testGetWalterWaiteRandomQuote),
        ("testCanGetRandomQuote", testCanGetRandomQuote)
    ]
}
