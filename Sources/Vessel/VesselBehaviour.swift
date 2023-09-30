import Foundation
import HTTPTypes

/// Can be implemented by a type that wishes to intercept the lifecycle of an operation
public protocol VesselBehaviour: AnyObject {

    /// Intercepts an ``HTTPRequest`` before it is performed
    ///
    /// Allows for mutation of the request to perform.
    ///
    /// - Parameters:
    ///   - client: The vessel client that is performing the request
    ///   - request: The request performed by the client
    ///   - httpRequest: The ``HTTPRequest`` that will be used during the whole operation
    func client<T: VesselRequest>(_ client: VesselClient, request: T, willBeginHTTPRequest httpRequest: inout HTTPRequest) async throws

    /// Intercepts an operation every time a response is received
    /// - Parameters:
    ///   - client: The vessel client that is performing the operation
    ///   - request: The request that has been performed by the client
    ///   - httpRequest: The ``HTTPRequest`` that has been performed by the client
    ///   - event: The ``VesselBehaviourEvent`` emitted by the client
    func client<T: VesselRequest>(_ client: VesselClient, request: T, httpRequest: HTTPRequest, didReceiveEvent event: VesselBehaviourEvent<T>) async throws
}

// MARK: - Default Behaviours

extension VesselBehaviour {
    public func client<T: VesselRequest>(_ client: VesselClient, request: T, willBeginHTTPRequest httpRequest: inout HTTPRequest) async throws { }
    public func client<T: VesselRequest>(_ client: VesselClient, request: T, httpRequest: HTTPRequest, didReceiveEvent event: VesselBehaviourEvent<T>) async throws { }
}
