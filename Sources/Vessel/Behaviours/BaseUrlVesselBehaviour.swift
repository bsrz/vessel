import Foundation
import HTTPTypes

/// A behaviour that sets the base URL of the request if not already set
public class BaseUrlVesselBehaviour: VesselBehaviour {

    /// A function that returns the base URL
    public let url: () -> String

    /// Initializes a new instance
    /// - Parameter url: A function that returns the base URL
    public init(url: @escaping () -> String) {
        self.url = url
    }

    /// Modifies the base URL of the request if the URL of the request doesn't have one set
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - request: The request that the client is performing
    ///   - httpRequest: The ``HTTPRequest`` that the behaviour can modify
    public func client<T: VesselRequest>(_ client: VesselClient, request: T, willBeginHTTPRequest httpRequest: inout HTTPRequest) async throws {
        if httpRequest.scheme == nil {
            httpRequest.scheme = "https"
        }
        if httpRequest.authority == nil {
            httpRequest.authority = url()
        }
    }
}
