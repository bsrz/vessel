@testable import Vessel
import HTTPTypes
import XCTest

extension HTTPField.Name {
    static let foo = HTTPField.Name("foo")!
    static let bar = HTTPField.Name("bar")!
    static let qux = HTTPField.Name("qux")!
}

class CommonHeadersVesselBehaviourTests: XCTestCase {
    func testBehaviour_addNewHeaders_doesntOverwriteExistingHeaders() async throws {
        let client = VesselClient(behaviours: [])
        let sut: VesselBehaviour = CommonHeadersVesselBehaviour {
            HTTPFields([
                HTTPField(name: .foo, value: "bar"),
                HTTPField(name: .bar, value: "foo"),
                HTTPField(name: .qux, value: "qux"),
            ])
        }
        let request = NoopRequest(headers: [.foo: "foo", .bar: "bar"])
        var requestType = try request.makeRequest()

        try await sut.client(client, request: request, willBeginHTTPRequest: &requestType.httpRequest)

        XCTAssertEqual(requestType.httpRequest.headerFields.count, 3)
        XCTAssertEqual(requestType.httpRequest.headerFields[.foo], "foo")
        XCTAssertEqual(requestType.httpRequest.headerFields[.bar], "bar")
        XCTAssertEqual(requestType.httpRequest.headerFields[.qux], "qux")
    }

    func testBehaviour_whenEmptyHeaders_doesntOverwriteExistingHeaders() async throws {
        let client = VesselClient(behaviours: [])
        let sut: VesselBehaviour = CommonHeadersVesselBehaviour { HTTPFields([]) }
        let request = NoopRequest(headers: [.foo: "foo", .bar: "bar"])
        var requestType = try request.makeRequest()

        try await sut.client(client, request: request, willBeginHTTPRequest: &requestType.httpRequest)

        XCTAssertEqual(requestType.httpRequest.headerFields.count, 2)
        XCTAssertEqual(requestType.httpRequest.headerFields[.foo], "foo")
        XCTAssertEqual(requestType.httpRequest.headerFields[.bar], "bar")
    }
}
