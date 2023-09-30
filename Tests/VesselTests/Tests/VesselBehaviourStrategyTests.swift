@testable import Vessel
import XCTest

class FooBehaviour: VesselBehaviour { }
class BarBehaviour: VesselBehaviour { }
class QuxBehaviour: VesselBehaviour { }

class VesselBehaviourStrategyTests: XCTestCase {

    func testStrategy_All_usesAllExistingBehaviours() {
        let behaviours: [any VesselBehaviour] = [FooBehaviour(), BarBehaviour(), QuxBehaviour()]
        let sut = VesselBehaviourStrategy.all
        let result = sut.include(behaviours)

        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result[0] is FooBehaviour)
        XCTAssertTrue(result[1] is BarBehaviour)
        XCTAssertTrue(result[2] is QuxBehaviour)
    }

    func testStrategy_None_usesNoneOfTheExistingBehaviours() {
        let behaviours: [any VesselBehaviour] = [FooBehaviour(), BarBehaviour(), QuxBehaviour()]
        let sut = VesselBehaviourStrategy.none
        let result = sut.include(behaviours)

        XCTAssertEqual(result.count, 0)
    }

    func testStrategy_ExcludeTypes_usesNoneOfTheExistingBehavioursOfTheSpecifiedTypes() {
        let behaviours: [any VesselBehaviour] = [FooBehaviour(), BarBehaviour(), QuxBehaviour()]
        let sut = VesselBehaviourStrategy.exclude([BarBehaviour.self])
        let result = sut.include(behaviours)

        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result[0] is FooBehaviour)
        XCTAssertTrue(result[1] is QuxBehaviour)
    }

    func testStrategy_ExcludeInstances_usesNoneOfTheExistingSpecifiedBehaviourIntances() {
        let behaviours: [any VesselBehaviour] = [FooBehaviour(), BarBehaviour(), QuxBehaviour()]
        let sut = VesselBehaviourStrategy.exclude([behaviours[1]])
        let result = sut.include(behaviours)

        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result[0] is FooBehaviour)
        XCTAssertTrue(result[1] is QuxBehaviour)
    }

    func testStrategy_OnlyTypes_usesOnlyTheExistingBehavioursOfTheSpecifiedTypes() {
        let behaviours: [any VesselBehaviour] = [FooBehaviour(), BarBehaviour(), QuxBehaviour()]
        let sut = VesselBehaviourStrategy.only([BarBehaviour.self])
        let result = sut.include(behaviours)

        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result[0] is BarBehaviour)
    }

    func testStrategy_OnlyInstances_usesOnlyTheExistingSpecifiedBehaviourIntances() {
        let behaviours: [any VesselBehaviour] = [FooBehaviour(), BarBehaviour(), QuxBehaviour()]
        let sut = VesselBehaviourStrategy.only([behaviours[1]])
        let result = sut.include(behaviours)

        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result[0] is BarBehaviour)
    }

    func testStrategy_Appending_addNewInstanceAtTheEndOfExistingBehaviours() {
        let behaviours: [any VesselBehaviour] = [FooBehaviour(), BarBehaviour()]
        let sut = VesselBehaviourStrategy.appending([QuxBehaviour()])
        let result = sut.include(behaviours)

        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result[0] is FooBehaviour)
        XCTAssertTrue(result[1] is BarBehaviour)
        XCTAssertTrue(result[2] is QuxBehaviour)
    }

    func testStrategy_Prepending_addNewInstanceAtTheBeginningOfExistingBehaviours() {
        let behaviours: [any VesselBehaviour] = [BarBehaviour(), QuxBehaviour()]
        let sut = VesselBehaviourStrategy.prepending([FooBehaviour()])
        let result = sut.include(behaviours)

        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result[0] is FooBehaviour)
        XCTAssertTrue(result[1] is BarBehaviour)
        XCTAssertTrue(result[2] is QuxBehaviour)
    }

    func testStrategy_whenReplacingFirst_replacesOnlyTheFirstOne() async throws {
        // Arrange
        let behaviours = [
            BaseUrlVesselBehaviour { "https://srz.io" },
            BaseUrlVesselBehaviour { "https://srz.com" }
        ]

        // Act
        let output = VesselBehaviourStrategy
            .replaceFirst(with: BaseUrlVesselBehaviour { "https://srz.net" })
            .include(behaviours)

        // Assert
        XCTAssertEqual(output.count, 2)

        let first = try XCTUnwrap(output.first as? BaseUrlVesselBehaviour)
        XCTAssertEqual(first.url(), "https://srz.net")

        let second = try XCTUnwrap(output[1] as? BaseUrlVesselBehaviour)
        XCTAssertEqual(second.url(), "https://srz.com")
    }

    func testStrategy_whenReplacingFirst_appendsBehaviourIfNotFound() async throws {
        // Arrange
        let behaviours: [VesselBehaviour] = []

        // Act
        let output = VesselBehaviourStrategy
            .replaceFirst(with: BaseUrlVesselBehaviour { "https://srz.net/" })
            .include(behaviours)

        // Assert
        XCTAssertEqual(output.count, 1)

        let first = try XCTUnwrap(output.first as? BaseUrlVesselBehaviour)
        XCTAssertEqual(first.url(), "https://srz.net/")
    }
}
