import Foundation
import HTTPTypes

/// Composes an ordered array of behaviours
public class CompositeVesselBehaviour: VesselBehaviour {

    /// An ordered array of behaviours to compose
    public let behaviours: [VesselBehaviour]

    /// Returns the number of behaviours
    public var count: Int { behaviours.count }

    /// Initializes a new composite behaviour
    /// - Parameter behaviours: The behaviour that the composite behaviour composes
    public init(behaviours: [VesselBehaviour]) {
        self.behaviours = behaviours
    }

    /// Composes the ``HTTPRequest`` mutated by each behaviour
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - request: The request that the client is performing
    ///   - httpRequest: The ``HTTPRequest`` that the behaviours can modify
    public func client<T: VesselRequest>(_ client: VesselClient, request: T, willBeginHTTPRequest httpRequest: inout HTTPRequest) async throws {
        for behaviour in behaviours {
            try await behaviour.client(client, request: request, willBeginHTTPRequest: &httpRequest)
        }
    }

    /// Forwards the event to all behaviours
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - request: The request that the client is performing
    ///   - httpRequest: The ``HTTPRequest`` that was performed
    ///   - event: The event that is occurring
    public func client<T: VesselRequest>(_ client: VesselClient, request: T, httpRequest: HTTPRequest, didReceiveEvent event: VesselBehaviourEvent<T>) async throws {
        for behaviour in behaviours {
            try await behaviour.client(client, request: request, httpRequest: httpRequest, didReceiveEvent: event)
        }
    }
}
