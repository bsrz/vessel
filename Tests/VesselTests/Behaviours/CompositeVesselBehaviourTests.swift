@testable import Vessel
import XCTest

class CompositeVesselBehaviourTests: XCTestCase {
    func testBehaviour_callsAllOtherBehaviours() async throws {
        // Arrange
        var willBegin: [Int] = []
        var received: [Int] = []
        var completed: [Int] = []

        let first = WitnessVesselBehaviour(
            willBegin: { willBegin.append(1); return $0 },
            received: { _ in received.append(1) },
            completed: { _ in completed.append(1) }
        )
        let second = WitnessVesselBehaviour(
            willBegin: { willBegin.append(2); return $0 },
            received: { _ in received.append(2) },
            completed: { _ in completed.append(2) }
        )

        // Act
        let client = VesselClient(
            behaviours: [
                BaseUrlVesselBehaviour.randomUser,
                first,
                second
            ]
        )
        try await client.perform(RandomUserOperation())

        // Assert
        XCTAssertEqual(willBegin, [1, 2])
        XCTAssertEqual(received, [1, 2])
        XCTAssertEqual(completed, [1, 2])
    }
}
