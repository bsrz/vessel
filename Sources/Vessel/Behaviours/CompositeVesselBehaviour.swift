import Foundation

/// Composes an ordered array of behaviours
class CompositeVesselBehaviour: VesselBehaviour {

    /// An ordered array of behaviours to compose
    let behaviours: [VesselBehaviour]

    /// Initializes a new composite behaviour
    /// - Parameter behaviours: The behaviour that the composite behaviour composes
    init(behaviours: [VesselBehaviour]) {
        self.behaviours = behaviours
    }

    /// Composes the request returned by each behaviour
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the behaviours can modify
    /// - Returns: The composed request of all behaviours
    func client<T: VesselOperation>(_ client: VesselClient, operationWillBegin operation: T, request: URLRequest) async throws -> URLRequest {
        var composed = request

        for behaviour in behaviours {
            composed = try await behaviour.client(client, operationWillBegin: operation, request: composed)
        }

        return composed
    }

    /// Forwards the received operation to all behaviours
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the client is performing
    ///   - response: The response received by the client
    func client<T: VesselOperation>(_ client: VesselClient, operationReceived operation: T, request: URLRequest, response: (Data, URLResponse)) async throws {
        for behaviour in behaviours {
            try await behaviour.client(client, operationReceived: operation, request: request, response: response)
        }
    }

    /// Forwards the completed operation to all behaviours
    /// - Parameters:
    ///   - client: The vessel client that owns this behaviour
    ///   - operation: The operation that the client is performing
    ///   - request: The request that the client is performing
    ///   - response: The response received by the client
    func client<T: VesselOperation>(_ client: VesselClient, operationCompleted operation: T, request: URLRequest, response: (Data, URLResponse, T.Response)) async throws {
        for behaviour in behaviours {
            try await behaviour.client(client, operationCompleted: operation, request: request, response: response)
        }
    }
}
