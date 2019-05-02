
import Foundation

enum DataResponseError: LocalizedError {
    case network(message: String)
    case decoding(message: String)
    
    var errorDescription: String? {
        switch self {
        case let .network(message), let .decoding(message):
            return message
        }
    }
}
