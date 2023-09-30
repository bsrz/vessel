import Foundation
import HTTPTypes

/// A behaviour that adds headers to a request
public class CommonHeadersVesselBehaviour: VesselBehaviour {

    /// A function that returns the headers to add to the request
    private let headers: () -> HTTPFields

    /// Initializes a new instance
    /// - Parameter headers: A function that returns the headers to add to the request
    public init(headers: @escaping () -> HTTPFields) {
        self.headers = headers
    }

    /// Modifies the headers of the ``HTTPRequest`` being performed
    ///
    /// This behaviour does *not* override headers that are already set on the request.
    ///
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - request: The request that the client is performing
    ///   - httpRequest: The request that the behaviour can modify
    public func client<T: VesselRequest>(_ client: VesselClient, request: T, willBeginHTTPRequest httpRequest: inout HTTPRequest) async throws {
        let headers = self.headers()
        guard !headers.isEmpty else { return }

        httpRequest.headerFields = httpRequest.headerFields.reduce(into: headers) { result, field in
            result[field.name] = field.value
        }
    }
}
