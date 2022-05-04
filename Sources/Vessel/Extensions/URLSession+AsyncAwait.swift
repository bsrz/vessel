import Foundation

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {

    /// A convenience method that bridge the gap between iOS 14 and iOS 15 support for modern concurrency
    /// - Parameter request: The request to perform
    /// - Returns: A tuple containing the data and the response received by the session
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }
            .resume()
        }
    }

    /// A convenience method that bridge the gap between iOS 14 and iOS 15 support for modern concurrency
    /// - Parameter request: The URL to fetch data from
    /// - Returns: A tuple containing the data and the response received by the session
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }
            .resume()
        }
    }
}
