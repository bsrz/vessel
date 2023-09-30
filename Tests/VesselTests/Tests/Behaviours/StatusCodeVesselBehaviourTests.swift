@testable import Vessel
import HTTPTypes
import XCTest

class StatusCodeVesselBehaviourTests: XCTestCase {

    func testBehaviour_givenStatusCodeInRange_doesNotThrowError() async throws {
        let client = VesselClient(behaviours: [])
        let request = HTTPRequest(
            method: .get ,
            scheme: "vessel",
            authority: "vessel.com",
            path: "/blackpearl",
            headerFields: [
                .contentType: "application/json",
                .accept: "application/json",
            ]
        )
        let response = HTTPResponse(
            status: .ok,
            headerFields: [
                .contentType: "application/json",
                .accept: "application/json",
            ]
        )

        let sut = StatusCodeVesselBehaviour(accepted: 200..<300)

        do {
            try await sut.client(
                client,
                request: NoopRequest(),
                httpRequest: request,
                didReceiveEvent: .received(
                    httpResponse: response,
                    data: Data()
                )
            )
        } catch {
            throw error
        }
    }

    func testBehaviour_givenStatusCodeOutOfRange_throwsError() async throws {
        let client = VesselClient(behaviours: [])
        let request = HTTPRequest(
            method: .get ,
            scheme: "vessel",
            authority: "vessel.com",
            path: "/blackpearl",
            headerFields: [
                .contentType: "application/json",
                .accept: "application/json",
            ]
        )
        let response = HTTPResponse(
            status: .ok,
            headerFields: [
                .contentType: "application/json",
                .accept: "application/json",
            ]
        )

        let sut = StatusCodeVesselBehaviour(accepted: 300..<400)

        do {
            try await sut.client(
                client,
                request: NoopRequest(),
                httpRequest: request,
                didReceiveEvent: .received(
                    httpResponse: response,
                    data: Data()
                )
            )
        } catch let error as StatusCodeVesselBehaviour.StatusCodeError {
            switch error {
            case .invalidStatusCode(let int):
                XCTAssertEqual(int, 200)
            }
        } catch {
            throw error
        }
    }
}

