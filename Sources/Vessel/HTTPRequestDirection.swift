import Foundation
import HTTPTypes

/// A simple type representing an ``HTTPRequest`` with and without a body
public enum HTTPRequestDirection {
    case download(HTTPRequest)
    case upload(HTTPRequest, body: Data)

    var httpRequest: HTTPRequest {
        get {
            switch self {
            case .upload(let request, body: _): return request
            case .download(let request): return request
            }
        }
        mutating set {
            switch self {
            case .upload(_, body: let body):
                self = .upload(newValue, body: body)

            case .download:
                self = .download(newValue)
            }
        }
    }
}
