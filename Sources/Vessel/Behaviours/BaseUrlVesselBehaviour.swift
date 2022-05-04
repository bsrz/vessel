import Foundation

/// A behaviour that sets the base URL of the request if not already set
public class BaseUrlVesselBehaviour: VesselBehaviour {

    /// A function that returns the base URL
    public let url: () -> URL

    /// Initializes a new instance
    /// - Parameter url: A function that returns the base URL
    public init(url: @escaping () -> URL) {
        self.url = url
    }

    /// Modifies the base URL of the request if the URL of the request doesn't have one set
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the behaviour can modify
    /// - Returns: A modified or unmodified request
    public func client<T: VesselOperation>(_ client: VesselClient, operationWillBegin operation: T, request: URLRequest) async throws -> URLRequest {
        var result = request
        result.url?.updateBaseIfNeeded(url())
        return result
    }
}

private extension URL {

    /// Updates the base URL of this URL
    /// - Parameter url: The base URL
    mutating func updateBaseIfNeeded(_ url: URL) {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            components.host.isNil,
            let updated = components.url(relativeTo: url)
        else { return }

        self = updated
    }
}
