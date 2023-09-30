import Foundation

final class MockURLProtocol: URLProtocol {
    typealias MockResponse = (URLRequest) -> (result: Result<Data, Error>, statusCode: Int?)

    static var mockResponses: [String: MockResponse] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }
        return mockResponses.keys.contains(url.withoutQuery())
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard
            let absoluteString = request.url?.withoutQuery(),
            let mock = Self.mockResponses[absoluteString]
        else { fatalError() }

        let response = mock(request)

        if let statusCode = response.statusCode, let httpURLResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ) {
            self.client?.urlProtocol(self, didReceive: httpURLResponse, cacheStoragePolicy: .notAllowed)
        }

        switch response.result {
        case let .success(data):
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)

        case let .failure(error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    override func stopLoading() { }
}

private extension URL {
    func withoutQuery() -> String {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { fatalError() }

        components.query = nil
        components.fragment = nil

        guard let absoluteString = components.url?.absoluteString else { fatalError() }
        return absoluteString
    }
}
