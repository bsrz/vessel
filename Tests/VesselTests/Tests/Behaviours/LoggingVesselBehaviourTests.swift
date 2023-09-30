@testable import Vessel
import HTTPTypes
import XCTest

class LoggingVesselBehaviourTests: XCTestCase {

    func testBehaviour_givenRequestWithInvalidURL_logsNothing() async throws {
        let client = VesselClient(behaviours: [])
        let request = HTTPRequest(
            method: .get ,
            scheme: nil,
            authority: nil,
            path: nil,
            headerFields: [:]
        )
        let response = HTTPResponse(status: .ok, headerFields: [.contentType: "application/json"])

        var logs: String?
        let sut = LoggingVesselBehaviour { logs = $0 }

        try await sut.client(client, request: NoopRequest(), httpRequest: request, didReceiveEvent: .received(httpResponse: response, data: Data()))

        XCTAssertNil(logs)
    }

    func testBehaviour_givenRequestAndReceivedResponseWithoutBody_logsAsExpected() async throws {
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

        var logs: String?
        let sut = LoggingVesselBehaviour { logs = $0 }

        try await sut.client(client, request: NoopRequest(), httpRequest: request, didReceiveEvent: .received(httpResponse: response, data: Data()))

        try XCTAssertEqual(XCTUnwrap(logs), """

        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        OPERATION:
        NoopRequest

        REQUEST:
        curl -v -X GET \\
        vessel://vessel.com/blackpearl \\
        -H 'accept: application/json' \\
        -H 'content-type: application/json'

        RECEIVED RESPONSE:
        Status: 200 OK
        -H 'accept: application/json'
        -H 'content-type: application/json'
        Body: <empty>
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        """)
    }

    func testBehaviour_givenRequestAndCompletedResponseWithoutBody_logsAsExpected() async throws {
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

        var logs: String?
        let sut = LoggingVesselBehaviour { logs = $0 }

        try await sut.client(
            client,
            request: NoopRequest(),
            httpRequest: request,
            didReceiveEvent: .completed(httpResponse: response, data: Data(), response: ())
        )

        try XCTAssertEqual(XCTUnwrap(logs), """

        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        OPERATION:
        NoopRequest

        REQUEST:
        curl -v -X GET \\
        vessel://vessel.com/blackpearl \\
        -H 'accept: application/json' \\
        -H 'content-type: application/json'

        COMPLETED RESPONSE:
        Status: 200 OK
        -H 'accept: application/json'
        -H 'content-type: application/json'
        Body: <empty>
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        """)
    }

    func testBehaviour_givenRequestAndReceivedResponseWithBody_logsAsExpected() async throws {
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
        let body = try XCTUnwrap("hello, world".data(using: .utf8))

        var logs: String?
        let sut = LoggingVesselBehaviour { logs = $0 }

        try await sut.client(client, request: NoopRequest(), httpRequest: request, didReceiveEvent: .received(httpResponse: response, data: body))

        try XCTAssertEqual(XCTUnwrap(logs), """

        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        OPERATION:
        NoopRequest

        REQUEST:
        curl -v -X GET \\
        vessel://vessel.com/blackpearl \\
        -H 'accept: application/json' \\
        -H 'content-type: application/json'

        RECEIVED RESPONSE:
        Status: 200 OK
        -H 'accept: application/json'
        -H 'content-type: application/json'
        Body: hello, world
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        """)
    }

    func testBehaviour_givenRequestAndCompletedResponseWithBody_logsAsExpected() async throws {
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
        let body = try XCTUnwrap("hello, world".data(using: .utf8))

        var logs: String?
        let sut = LoggingVesselBehaviour { logs = $0 }

        try await sut.client(
            client,
            request: NoopRequest(),
            httpRequest: request,
            didReceiveEvent: .completed(httpResponse: response, data: body, response: ())
        )

        try XCTAssertEqual(XCTUnwrap(logs), """

        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        OPERATION:
        NoopRequest

        REQUEST:
        curl -v -X GET \\
        vessel://vessel.com/blackpearl \\
        -H 'accept: application/json' \\
        -H 'content-type: application/json'

        COMPLETED RESPONSE:
        Status: 200 OK
        -H 'accept: application/json'
        -H 'content-type: application/json'
        Body: hello, world
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        """)
    }
}
