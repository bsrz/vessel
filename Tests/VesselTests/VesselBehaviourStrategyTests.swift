@testable import Vessel
import XCTest

class VesselBehaviourStrategyTests: XCTestCase {
    func testStrategy_whenReplacingFirst_replacesOnlyTheFirstOne() async throws {
        // Arrange
        let behaviours = [
            BaseUrlVesselBehaviour { URL(string: "https://srz.io/")! },
            BaseUrlVesselBehaviour { URL(string: "https://srz.com/")! }
        ]

        // Act
        let output = VesselBehaviourStrategy
            .replaceFirst(with: BaseUrlVesselBehaviour { URL(string: "https://srz.net/")! })
            .include(behaviours)

        // Assert
        XCTAssertEqual(output.count, 2)

        let first = try XCTUnwrap(output.first as? BaseUrlVesselBehaviour)
        XCTAssertEqual(first.url(), URL(string: "https://srz.net/")!)

        let second = try XCTUnwrap(output[1] as? BaseUrlVesselBehaviour)
        XCTAssertEqual(second.url(), URL(string: "https://srz.com/")!)
    }
    func testStrategy_whenReplacingFirst_appendsBehaviourIfNotFound() async throws {
        // Arrange
        let behaviours: [VesselBehaviour] = []

        // Act
        let output = VesselBehaviourStrategy
            .replaceFirst(with: BaseUrlVesselBehaviour { URL(string: "https://srz.net/")! })
            .include(behaviours)

        // Assert
        XCTAssertEqual(output.count, 1)

        let first = try XCTUnwrap(output.first as? BaseUrlVesselBehaviour)
        XCTAssertEqual(first.url(), URL(string: "https://srz.net/")!)
    }
}
