@testable import Vessel
import XCTest

class BaseUrlVesselBehaviourTests: XCTestCase {
    func testBehaviour_whenNoBaseURL_prependsBaseUrl() async throws {
        struct Operation: VesselOperation {
            typealias Response = Int
            func makeRequest() throws -> URLRequest {
                let url = URL(string: "operation")!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
        }

        // Arrange
        let client = VesselClient(behaviours: [])
        let baseUrl = URL(string: "https://srz.io/")!
        let sut = BaseUrlVesselBehaviour { baseUrl }
        let operation = Operation()
        let request = try operation.makeRequest()

        // Act
        let output = try await sut.client(client, operationWillBegin: operation, request: request)

        // Assert
        XCTAssertEqual(output.url, URL(string: "operation", relativeTo: baseUrl))
    }
    func testBehaviour_whenFullBaseURL_requestIsNotModified() async throws {
        struct Operation: VesselOperation {
            typealias Response = Int
            func makeRequest() throws -> URLRequest {
                let url = URL(string: "http://srz.com/operation")!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
        }

        // Arrange
        let client = VesselClient(behaviours: [])
        let baseUrl = URL(string: "https://srz.io/")!
        let sut = BaseUrlVesselBehaviour { baseUrl }
        let operation = Operation()
        let request = try operation.makeRequest()

        // Act
        let output = try await sut.client(client, operationWillBegin: operation, request: request)

        // Assert
        XCTAssertEqual(output.url, URL(string: "http://srz.com/operation"))
    }
}
