@testable import Vessel
import XCTest

class OptionalConvenienceTests: XCTestCase {

    func test_givenNonNilValue_whenUsingOrMethod_returnsNonOptionalValue() {
        let sut = Int("42").or(0)
        XCTAssertEqual(sut, 42)
    }

    func test_givenNilValue_whenUsingOrMethod_returnsDefaultValue() {
        let sut = Int("abc").or(42)
        XCTAssertEqual(sut, 42)
    }

    func test_givenNonNilValue_whenIsNil_returnsFalse() {
        let sut: Int? = 42
        XCTAssertFalse(sut.isNil)
    }

    func test_givenNilValue_whenIsNil_returnsTrue() {
        let sut: Int? = nil
        XCTAssertTrue(sut.isNil)
    }

    func test_givenNonNilValue_whenIsNotNil_returnsTrue() {
        let sut: Int? = 42
        XCTAssertTrue(sut.isNotNil)
    }

    func test_givenNilValue_whenIsNil_returnsFalse() {
        let sut: Int? = nil
        XCTAssertFalse(sut.isNotNil)
    }
}

