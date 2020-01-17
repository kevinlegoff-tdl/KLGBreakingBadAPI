import Foundation


public protocol BreakingBadApiClient {
    var baseURL: URL {get}
    var allCharactersEndoint: URL { get }
    var randomQuoteEndpoint: URL { get }

    func allTVCharacters(using urlSession: URLSession, _ completion:  @escaping CharactersCallback)

    func randomQuote(using urlSession: URLSession, fromCharacterWithName name: String, _ completion: @escaping QuoteCallback)

    func randomQuote(using urlSession: URLSession, _ completion: @escaping QuoteCallback)
}

public typealias QuoteCallback = (ResponseData<Quote>) -> Void
public typealias CharactersCallback = (ResponseData<[Character]>) -> Void

extension BreakingBadApiClient {

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

    public var randomQuoteEndpoint: URL {
        get{
            return quoteEndpoint
                .appendingPathComponent("random")
        }
    }

    public func allTVCharacters(using urlSession: URLSession = URLSession(configuration: .ephemeral), _ completion:  @escaping CharactersCallback) {
        loadData(using: urlSession, from: allCharactersEndoint, completion)
    }

    public func randomQuote(using urlSession: URLSession = URLSession(configuration: .ephemeral), fromCharacterWithName name: String, _ completion: @escaping QuoteCallback) {
        let url = buildQuoteFromCharacterURL(name: name)
        loadRandomQuote(using: urlSession, from: url, completion: completion)
    }

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

public class BreakingBadRestApiClient: BreakingBadApiClient {

    public var baseURL: URL

    public init(baseURL: URL = URL(string: "https://www.breakingbadapi.com/api")!) {
        self.baseURL = baseURL
    }
}


