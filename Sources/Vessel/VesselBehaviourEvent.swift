import Foundation
import HTTPTypes

/// Describes an event emitted by a ``VesselClient`` that can be handled by a ``VesselBehaviour``
public enum VesselBehaviourEvent<T: VesselRequest> {

    /// A response has been received by the client
    case received(httpResponse: HTTPResponse, data: Data)

    /// A response has been completed by the client
    case completed(httpResponse: HTTPResponse, data: Data, response: T.ResponseType)

    /// Returns the underlying ``HTTPResponse`` of the event
    var httpResponse: HTTPResponse {
        switch self {
        case .received(httpResponse: let response, data: _): return  response
        case .completed(httpResponse: let response, data: _, response: _): return response
        }
    }
}
