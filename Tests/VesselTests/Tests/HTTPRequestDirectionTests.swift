@testable import Vessel
import HTTPTypes
import XCTest

class HTTPRequestDirectionTests: XCTestCase {

    func test_givenUploadRequestDirection_whenHTTPRequestPropertiesAreMutated_thenSelfIsMutated() throws {
        let startingHttpRequest = HTTPRequest(
            method: .get,
            scheme: nil,
            authority: nil,
            path: nil,
            headerFields: [
                .accept: "application/json"
            ]
        )

        let startingBody = try XCTUnwrap("starting body".data(using: .utf8))

        var sut: HTTPRequestDirection = .upload(startingHttpRequest, body: startingBody)

        XCTAssertEqual(sut.httpRequest.method, .get)
        XCTAssertNil(sut.httpRequest.scheme)
        XCTAssertNil(sut.httpRequest.authority)
        XCTAssertNil(sut.httpRequest.path)
        XCTAssertEqual(sut.httpRequest.headerFields, [.accept: "application/json"])

        sut.httpRequest.method = .post
        sut.httpRequest.scheme = "https"
        sut.httpRequest.authority = "apple.com"
        sut.httpRequest.path = "/"
        sut.httpRequest.headerFields = [.accept: "application/xml"]

        XCTAssertEqual(sut.httpRequest.method, .post)
        XCTAssertEqual(sut.httpRequest.scheme, "https")
        XCTAssertEqual(sut.httpRequest.authority, "apple.com")
        XCTAssertEqual(sut.httpRequest.path, "/")
        XCTAssertEqual(sut.httpRequest.headerFields, [.accept: "application/xml"])
    }

    func test_givenDownloadRequestDirection_whenHTTPRequestPropertiesAreMutated_thenSelfIsMutated() throws {
        let startingHttpRequest = HTTPRequest(
            method: .get,
            scheme: nil,
            authority: nil,
            path: nil,
            headerFields: [
                .accept: "application/json"
            ]
        )

        var sut: HTTPRequestDirection = .download(startingHttpRequest)

        XCTAssertEqual(sut.httpRequest.method, .get)
        XCTAssertNil(sut.httpRequest.scheme)
        XCTAssertNil(sut.httpRequest.authority)
        XCTAssertNil(sut.httpRequest.path)
        XCTAssertEqual(sut.httpRequest.headerFields, [.accept: "application/json"])

        sut.httpRequest.method = .post
        sut.httpRequest.scheme = "https"
        sut.httpRequest.authority = "apple.com"
        sut.httpRequest.path = "/"
        sut.httpRequest.headerFields = [.accept: "application/xml"]

        XCTAssertEqual(sut.httpRequest.method, .post)
        XCTAssertEqual(sut.httpRequest.scheme, "https")
        XCTAssertEqual(sut.httpRequest.authority, "apple.com")
        XCTAssertEqual(sut.httpRequest.path, "/")
        XCTAssertEqual(sut.httpRequest.headerFields, [.accept: "application/xml"])
    }
}

