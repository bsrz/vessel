import Foundation

/// A behaviour that adds headers to a request
public class CommonHeadersVesselBehaviour: VesselBehaviour {

    /// A function that returns the headers to add to the request
    private let headers: () -> [String: String]

    /// Initializes a new instance
    /// - Parameter headers: A function that returns the headers to add to the request
    public init(headers: @escaping () -> [String: String]) {
        self.headers = headers
    }

    /// Modifies the headers of the URL request being performed
    ///
    /// This behaviour does _not_ override headers that are already set on the request.
    ///
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the behaviour can modify
    /// - Returns: A modified or unmodified request
    public func client<T: VesselOperation>(_ client: VesselClient, operationWillBegin operation: T, request: URLRequest) async throws -> URLRequest {
        var request = request

        let headers = self.headers()
        let existing = request.allHTTPHeaderFields.or([:]).keys

        for key in headers.keys where !existing.contains(key) {
            request.addValue(headers[key]!, forHTTPHeaderField: key)
        }

        return request
    }
}
