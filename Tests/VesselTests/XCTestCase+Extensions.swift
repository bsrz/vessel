@testable import Vessel
import HTTPTypes
import XCTest

extension XCTestCase {
    struct NoopRequest: VesselRequest {
        typealias ResponseType = Void

        var authority: String? = "noop.com"
        var isDownload = true
        var headers: HTTPFields = [:]

        func makeRequest() throws -> HTTPRequestDirection {
            if isDownload {
                return .download(
                    HTTPRequest(
                        method: .get,
                        scheme: "https",
                        authority: authority,
                        path: "/noop",
                        headerFields: headers
                    )
                )
            } else {
                return .upload(
                    HTTPRequest(
                        method: .post,
                        scheme: "https",
                        authority: authority,
                        path: "/noop",
                        headerFields: headers
                    ),
                    body: Data()
                )
            }
        }
    }
}
