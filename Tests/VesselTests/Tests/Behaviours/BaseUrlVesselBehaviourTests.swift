@testable import Vessel
import HTTPTypes
import XCTest

class BaseUrlVesselBehaviourTests: XCTestCase {
    func testBehaviour_givenNoBaseURL_whenWillBegingIsCalled_mutatesHTTPRequestWithAuthority() async throws {
        let client = VesselClient(behaviours: [])
        let sut: VesselBehaviour = BaseUrlVesselBehaviour { "apple.com" }
        let request = NoopRequest(authority: nil)
        var requestType = try request.makeRequest()
        try await sut.client(client, request: request, willBeginHTTPRequest: &requestType.httpRequest)

        XCTAssertEqual(requestType.httpRequest.authority, "apple.com")
    }

    func testBehaviour_givenBaseURL_whenWillBegingIsCalled_doesNotMutateHTTPRequest() async throws {
        let client = VesselClient(behaviours: [])
        let sut: VesselBehaviour = BaseUrlVesselBehaviour { "apple.com" }
        let request = NoopRequest()
        var requestType = try request.makeRequest()
        try await sut.client(client, request: request, willBeginHTTPRequest: &requestType.httpRequest)

        XCTAssertEqual(requestType.httpRequest.authority, "noop.com")
    }
}
