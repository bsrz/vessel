@testable import Vessel
import XCTest

extension XCTestCase {
    struct RandomUserOperation: VesselOperation {
        typealias Response = String
        func makeRequest() throws -> URLRequest {
            let url = URL(string: "api")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
    }
}
