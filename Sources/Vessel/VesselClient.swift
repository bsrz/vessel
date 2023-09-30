import Combine
import Foundation
import HTTPTypes
import HTTPTypesFoundation
import SwiftUI

/// A client that performs operations
public class VesselClient: ObservableObject {

    /// The composite behaviour that runs the lifecycle of each operation through an ordered array of mutating behaviours
    public private(set) var behaviour: CompositeVesselBehaviour

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
    public func perform<T: VesselRequest>(_ request: T) async throws -> T.ResponseType {
        var requestDirection = try request.makeRequest()
        try await behaviour.client(self, request: request, willBeginHTTPRequest: &requestDirection.httpRequest)
        let (data, httpResponse): (Data, HTTPResponse)

        switch requestDirection {
        case .download(let httpRequest):
            (data, httpResponse) = try await session.data(for: httpRequest)

        case .upload(let httpRequest, body: let body):
            (data, httpResponse) = try await session.upload(for: httpRequest, from: body)
        }

        try await behaviour.client(
            self,
            request: request,
            httpRequest: requestDirection.httpRequest,
            didReceiveEvent: .received(
                httpResponse: httpResponse,
                data: data
            )
        )

        let response = try request.handle(received: data)

        try await behaviour.client(
            self,
            request: request,
            httpRequest: requestDirection.httpRequest,
            didReceiveEvent: .completed(
                httpResponse: httpResponse,
                data: data,
                response: response
            )
        )

        return response
    }
}
