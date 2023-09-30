@testable import Vessel
import XCTest

import HTTPTypes
import HTTPTypesFoundation

class VesselClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDown() {
        MockURLProtocol.mockResponses.removeAll()
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }

    func testClient_givenDownloadRequest_whenPerformingRequest_thenCallsAllBehaviourMethods() async throws {
        MockURLProtocol.mockResponses["https://noop.com/noop"] = { _ in
            (result: .success(Data()), statusCode: 200)
        }

        var willBegin = false
        var didReceive = false
        var didComplete = false

        let witness = WitnessVesselBehaviour(
            willBegin: { willBegin = true },
            didReceive: { didReceive = true },
            didComplete: { didComplete = true }
        )

        let client = VesselClient(behaviours: [witness])

        try await client.perform(NoopRequest(isDownload: true))

        XCTAssertTrue(willBegin)
        XCTAssertTrue(didReceive)
        XCTAssertTrue(didComplete)
    }

    func testClient_givenUploadRequest_whenPerformingRequest_thenCallsAllBehaviourMethods() async throws {
        MockURLProtocol.mockResponses["https://noop.com/noop"] = { _ in
            (result: .success(Data()), statusCode: 200)
        }

        var willBegin = false
        var didReceive = false
        var didComplete = false

        let witness = WitnessVesselBehaviour(
            willBegin: { willBegin = true },
            didReceive: { didReceive = true },
            didComplete: { didComplete = true }
        )

        let client = VesselClient(behaviours: [witness])

        try await client.perform(NoopRequest(isDownload: false))

        XCTAssertTrue(willBegin)
        XCTAssertTrue(didReceive)
        XCTAssertTrue(didComplete)
    }

    func testClient_givenExistingBehaviours_whenUpdatingBehaviour_thenClientUsesUpdatedBehaviours() async throws {
        MockURLProtocol.mockResponses["https://noop.com/noop"] = { _ in
            (result: .success(Data()), statusCode: 200)
        }

        var willBegin = false
        var didReceive = false
        var didComplete = false

        let witness = WitnessVesselBehaviour(
            willBegin: { willBegin = true },
            didReceive: { didReceive = true },
            didComplete: { didComplete = true }
        )

        let client = VesselClient(behaviours: [])
        XCTAssertEqual(client.behaviour.count, 0)

        client.updateBehaviours(with: .appending([witness]))

        try await client.perform(NoopRequest())

        XCTAssertTrue(willBegin)
        XCTAssertTrue(didReceive)
        XCTAssertTrue(didComplete)
    }
}
