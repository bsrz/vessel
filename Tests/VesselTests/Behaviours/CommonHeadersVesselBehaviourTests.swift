@testable import Vessel
import XCTest

class CommonHeadersVesselBehaviourTests: XCTestCase {
    func testBehaviour_addNewHeaders_doesntOverwriteExistingHeaders() async throws {
        // Arrange
        var request = URLRequest(url: URL(string: "https://srz.com/")!)
        request.addValue("foo", forHTTPHeaderField: "foo")

        let sut = CommonHeadersVesselBehaviour {
            ["foo": "bar", "bar": "foo"]
        }

        // Act
        let client = VesselClient(behaviours: [])
        let output = try await sut.client(client, operationWillBegin: RandomUserOperation(), request: request)

        // Assert
        XCTAssertEqual(output.allHTTPHeaderFields?["foo"], "foo")
        XCTAssertEqual(output.allHTTPHeaderFields?["bar"], "foo")
    }
}
