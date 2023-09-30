import Foundation
import HTTPTypes

/// Protocol to implement for a ``VesselRequest`` that can be used with the ``VesselClient``
public protocol VesselRequest {

    /// The type of the response returned as a result of the ``handle(received:)`` method
    associatedtype ResponseType

    /// Generate an ``HTTPRequest`` for this ``VesselRequest``.
    ///
    /// This method is called by the ``VesselClient``.
    func makeRequest() throws -> HTTPRequestDirection

    /// Handle the raw response object returned by the server.
    ///
    /// This method is called by the ``VesselClient`` after a successful call to the the API server.
    /// - Parameter response: The raw response data received by the client
    /// - Returns: A ``ResponseType`` object containing the decoded response.
    func handle(received: Data) throws -> ResponseType
}
