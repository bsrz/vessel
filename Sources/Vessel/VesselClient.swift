import Combine
import Foundation
import SwiftUI

/// A client that performs operations
public class VesselClient: ObservableObject {

    /// The composite behaviour that runs the lifecycle of each operation through an ordered array of mutating behaviours
    private var behaviour: CompositeVesselBehaviour

    /// The `URLSession` used by the client
    private let session: URLSession

    /// Initializes a new client with behaviours and a `URLSession`
    /// - Parameters:
    ///   - behaviours: An ordered array of mutating behaviours
    ///   - session: The `URLSession` to use when performing operations
    public init(behaviours: [VesselBehaviour], session: URLSession = .shared) {
        self.behaviour = CompositeVesselBehaviour(behaviours: behaviours)
        self.session = session
    }

    /// Updates the ordered array of behaviours
    /// - Parameter strategy: The strategy to use when updating behaviours
    public func updateBehaviours(with strategy: VesselBehaviourStrategy) {
        behaviour = .init(behaviours: strategy.include(behaviour.behaviours))
    }

    @discardableResult
    /// Performs an operation
    /// - Parameter operation: The operation to perform
    /// - Returns: The response of the operation
    public func perform<T: VesselOperation>(_ operation: T) async throws -> T.Response {
        let initial = try operation.makeRequest()

        let request = try await behaviour.client(self, operationWillBegin: operation, request: initial)

        let response = try await session.data(for: request)

        try await behaviour.client(self, operationReceived: operation, request: request, response: response)

        let result = try operation.handleResponse(response.0)

        try await behaviour.client(self, operationCompleted: operation, request: request, response: (response.0, response.1, result))

        return result
    }
}
