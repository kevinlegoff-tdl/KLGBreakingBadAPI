import Foundation


public protocol BreakingBadApiClient {
    var baseURL: URL {get}
    var allCharactersEndoint: URL { get }
    var randomQuoteEndpoint: URL { get }

    func allTVCharacters(using urlSession: URLSession, _ completion:  @escaping CharactersCallback)

    func randomQuote(using urlSession: URLSession, fromCharacterWithName name: String, _ completion: @escaping QuoteCallback)

    func randomQuote(using urlSession: URLSession, _ completion: @escaping QuoteCallback)
}

/// Simple type alias for function that is called when a  quote is loaded
public typealias QuoteCallback = (ResponseData<Quote>) -> Void

/// Simple type alias for function that is called when the list of characters is loaded
public typealias CharactersCallback = (ResponseData<[Character]>) -> Void

extension BreakingBadApiClient {


    /// Endpoint used to retreive the list of `Character`
    public var allCharactersEndoint: URL {
        get{
            return baseURL.appendingPathComponent("characters")
        }
    }

    var quoteEndpoint: URL {
        get{
            return baseURL
                .appendingPathComponent("quote")
        }
    }

    /// Endpoint used to retreive a random `Quote`
    public var randomQuoteEndpoint: URL {
        get{
            return quoteEndpoint
                .appendingPathComponent("random")
        }
    }

    /// Send a request to the server to getAlltheCaharcters from the break bad series
    /// - Parameter  using: the url session that will be used to make the web service call
    /// - Parameter  completion: the function invoked once the web sevice as returned data as an array of `Character` or an `Error` if one occured. The completion callback is not executed on the main thread
    public func allTVCharacters(using urlSession: URLSession = URLSession(configuration: .ephemeral), _ completion:  @escaping CharactersCallback) {
        loadData(using: urlSession, from: allCharactersEndoint, completion)
    }

    /// Send a request to the server to getAlltheCaharcters from the break bad series
    /// - Parameter  using: the url session that will be used to make the web service call
    /// - Parameter  name: the character name author of the random quote
    /// - Parameter  completion: the function invoked once the web sevice as returned data as a single `Quote` or an `Error` if one occured. The completion callback is not executed on the main thread
    public func randomQuote(using urlSession: URLSession = URLSession(configuration: .ephemeral), fromCharacterWithName name: String, _ completion: @escaping QuoteCallback) {
        let url = buildQuoteFromCharacterURL(name: name)
        loadRandomQuote(using: urlSession, from: url, completion: completion)
    }

    /// Send a request to the server to getAlltheCaharcters from the break bad series
    /// - Parameter  using: the url session that will be used to make the web service call
    /// - Parameter  completion: the function invoked once the web sevice as returned data as a single `Quote` or an `Error` if one occured. The completion callback is not executed on the main thread
    public func randomQuote(using urlSession: URLSession = URLSession(configuration: .ephemeral), _ completion: @escaping QuoteCallback) {
        loadRandomQuote(using: urlSession, from: randomQuoteEndpoint, completion: completion)
    }

    func buildQuoteFromCharacterURL(name: String) -> URL{
        return randomQuoteEndpoint.appendingQuery(key: "author", value: name)
    }

    private func loadRandomQuote(using urlSession:URLSession, from: URL, completion: @escaping QuoteCallback) {
        loadData(using: urlSession, from: from) { (response: ResponseData<[Quote]>) in
            if let err = response.error {
                completion( ResponseData.error(err))
                return
            }
            if let quote = response.data?.first {
                completion(ResponseData.success(quote))
            } else {
                completion( ResponseData.error(.noQuoteForThisCharacter))
            }
        }
    }

    private func loadData<T: Decodable>(using session: URLSession,from endpoint: URL, _ completion: @escaping (ResponseData<T>) -> Void) {
        let retriever = session.dataTask(with: endpoint) { data, response, error  in
            if let err = error {
                completion(ResponseData.error(err))
                return
            }

            guard let response = response as? HTTPURLResponse else{
                completion(ResponseData.error(.notHttpResponse))
                return
            }

            if response.statusCode != 200 {
                completion(ResponseData.error(.notStatusOk(status: response.statusCode)))
                return
            }

            let data = data!
            let decodedData = try? JSONDecoder().decode(T.self, from: data)
            guard let result = decodedData else {
                completion(ResponseData.error(.notAbleToDecodeData))
                return
            }
            completion(ResponseData.success(result))

        }
        retriever.resume()
    }
}

/// Default implementation for a Breaking bad API Client
public class BreakingBadRestApiClient: BreakingBadApiClient {

    /// Base url of the server this is used as the root to build endpoints URLs
    public var baseURL: URL

    /// init the default client with the URL given as parameter
    /// of fall back to https://www.breakingbadapi.com/api if no url is passed
    /// - Parameter baseURL: the URL of the server that is used by the client
    public init(baseURL: URL = URL(string: "https://www.breakingbadapi.com/api")!) {
        self.baseURL = baseURL
    }
}


