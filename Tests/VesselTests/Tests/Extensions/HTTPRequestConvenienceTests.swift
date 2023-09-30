@testable import Vessel
import HTTPTypes
import XCTest

class HTTPRequestConvenienceTests: XCTestCase {

    func test_initializingNewHTTPRequest_defaultParametersAreUsed() async throws {
        let sut = HTTPRequest()
        XCTAssertEqual(sut.method, .get)
        XCTAssertNil(sut.path)
        XCTAssertNil(sut.authority)
        XCTAssertTrue(sut.headerFields.isEmpty)
    }
}

