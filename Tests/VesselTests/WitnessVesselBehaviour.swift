import Foundation
import HTTPTypes
import Vessel

class WitnessVesselBehaviour: VesselBehaviour {

    let willBegin: () -> Void
    let didReceive: () -> Void
    let didComplete: () -> Void

    init(willBegin: @escaping () -> Void = { }, didReceive: @escaping () -> Void = { }, didComplete: @escaping () -> Void = { }) {
        self.willBegin = willBegin
        self.didReceive = didReceive
        self.didComplete = didComplete
    }

    // MARK: - Network Behaviour

    func client<T: VesselRequest>(_ client: VesselClient, request: T, willBeginHTTPRequest httpRequest: inout HTTPRequest) async throws {
        willBegin()
    }

    func client<T: VesselRequest>(_ client: VesselClient, request: T, httpRequest: HTTPRequest, didReceiveEvent event: VesselBehaviourEvent<T>) async throws {
        switch event {
        case .received:
            didReceive()

        case .completed:
            didComplete()
        }
    }
}
