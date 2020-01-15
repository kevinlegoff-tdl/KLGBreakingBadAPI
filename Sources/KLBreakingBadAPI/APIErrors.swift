
import Foundation

public enum BreakingBadApiClientError: Error {
    case notStatusOk(status: Int)
    case notAbleToDecodeData
    case notHttpResponse
    case noQuoteForThisCharacter
}

extension ResponseData {
    static func error(_ error: BreakingBadApiClientError) -> ResponseData {
        return ResponseData(data: nil, error: error)
    }
}
