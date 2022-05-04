import Foundation
import Vessel

class WitnessVesselBehaviour: VesselBehaviour {

    typealias WillBegin = (URLRequest) async throws -> URLRequest
    typealias Received = ((Data, URLResponse)) async throws -> Void
    typealias Completed = ((Data, URLResponse)) async throws -> Void

    private let willBegin: WillBegin?
    private let received: Received?
    private let completed: Completed?

    init(willBegin: WillBegin?, received: Received?, completed: Completed?) {
        self.willBegin = willBegin
        self.received = received
        self.completed = completed
    }

    // MARK: - Network Behaviour
    func client<T: VesselOperation>(_ client: VesselClient, operationWillBegin operation: T, request: URLRequest) async throws -> URLRequest {
        try await willBegin?(request) ?? request
    }
    func client<T: VesselOperation>(_ client: VesselClient, operationReceived operation: T, request: URLRequest, response: (Data, URLResponse)) async throws {
        try await received?(response)
    }
    func client<T: VesselOperation>(_ client: VesselClient, operationCompleted operation: T, request: URLRequest, response: (Data, URLResponse, T.Response)) async throws {
        try await completed?((response.0, response.1))
    }
}
