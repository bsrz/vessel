@testable import Vessel
import HTTPTypes
import XCTest

class CompositeVesselBehaviourTests: XCTestCase {
    func testBehaviour_withMultipleSubBehaviours_forwardsBehaviourEventsInOrder() async throws {
        var values: [String] = []
        let first = WitnessVesselBehaviour(
            willBegin: { values.append("will begin first") },
            didReceive: { values.append("did receive first") },
            didComplete: { values.append("did complete first") }
        )
        let second = WitnessVesselBehaviour(
            willBegin: { values.append("will begin second") },
            didReceive: { values.append("did receive second") },
            didComplete: { values.append("did complete second") }
        )
        let sut = CompositeVesselBehaviour(behaviours: [first, second])
        let client = VesselClient (behaviours: [])
        var httpRequest = HTTPRequest()
        let httpResponse = HTTPResponse(status: 200)

        try await sut.client(
            client,
            request: NoopRequest(),
            willBeginHTTPRequest: &httpRequest
        )
        try await sut.client(
            client,
            request: NoopRequest(),
            httpRequest: httpRequest,
            didReceiveEvent: .received(
                httpResponse: httpResponse,
                data: Data()
            )
        )
        try await sut.client(
            client,
            request: NoopRequest(),
            httpRequest: httpRequest,
            didReceiveEvent: .completed(
                httpResponse: httpResponse,
                data: Data(),
                response: ()
            )
        )

        XCTAssertEqual(
            values,
            [
                "will begin first",
                "will begin second",
                "did receive first",
                "did receive second",
                "did complete first",
                "did complete second"
            ]
        )
    }
}
