import Foundation
import HTTPTypes

/// A behaviour that validates the status code of a response
public class StatusCodeVesselBehaviour: VesselBehaviour {

    /// An error that can be thrown during validation
    enum StatusCodeError: Error {

        /// Thrown if the status code isn't valid
        case invalidStatusCode(Int)
    }

    /// The range of accepted status codes
    private let range: Range<Int>

    /// Initializes a new instance
    /// - Parameter accepted: The range of accepted status codes
    public init(accepted: Range<Int>) {
        self.range = accepted
    }

    /// Validates that the status code received is within the accepted range
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - request: The request that the client is performing
    ///   - httpRequest: The ``HTTPRequest`` that was performed
    ///   - event: The event that is occurring
    public func client<T: VesselRequest>(_ client: VesselClient, request: T, httpRequest: HTTPRequest, didReceiveEvent event: VesselBehaviourEvent<T>) async throws {
        guard range.contains(event.httpResponse.status.code) else { throw StatusCodeError.invalidStatusCode(event.httpResponse.status.code) }
    }
}
