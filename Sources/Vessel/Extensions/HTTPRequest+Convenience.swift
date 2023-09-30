import HTTPTypes

extension HTTPRequest {

    /// Initializes a new ``HTTPRequest`` with default parameters
    /// - Parameters:
    ///   - method: The HTTP method of the request
    ///   - path: The path of th request (i.e. after the host)
    ///   - headerFields: The headers of the request
    public init(method: HTTPRequest.Method = .get, path: String? = nil, headerFields: HTTPFields = [:]) {
        self.init(method: method, scheme: nil, authority: nil, path: path, headerFields: headerFields)
    }
}
