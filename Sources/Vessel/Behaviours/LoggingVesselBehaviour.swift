import Foundation
import HTTPTypes
import os.log

/// A behaviour that can log the requests and responses that are performed and received by the client
public class LoggingVesselBehaviour: VesselBehaviour {

    /// A function that is given a string representation of the request and response
    private let logger: (String) -> Void

    /// Initializes a new instance
    /// - Parameter logger: A function that is given a string representation of the request and response
    public init(logger: ((String) -> Void)? = nil) {
        self.logger = logger ?? { os_log("%s", log: .vessel, $0) }
    }

    /// Calls the logger function with a string representation of the request and response
    /// - Parameters:
    ///   - client: he vessel client that owns this behaviour
    ///   - request: The request that the client is performing
    ///   - httpRequest: The ``HTTPRequest`` that the client has performed
    ///   - event: The ``VesselBehaviourEvent`` that is being handled
    public func client<T: VesselRequest>(_ client: VesselClient, request: T, httpRequest: HTTPRequest, didReceiveEvent event: VesselBehaviourEvent<T>) async throws {
        guard let url = httpRequest.url?.absoluteString else { return }
        
        var requestLines: [String] = [
            "curl -v -X \(httpRequest.method)", url
        ]

        let headers = httpRequest.headerFields
            .sorted { $0.name.canonicalName < $1.name.canonicalName }
            .map { "-H '\($0.name.canonicalName): \($0.value)'" }

        requestLines.append(contentsOf: headers)

        var responseLines: [String] = []

        switch event {
        case .received(let httpResponse, let data):
            responseLines += ["RECEIVED RESPONSE:"]
            responseLines += lines(for: httpResponse)
            responseLines += lines(for: data)

        case .completed(let httpResponse, let data, _):
            responseLines += ["COMPLETED RESPONSE:"]
            responseLines += lines(for: httpResponse)
            responseLines += lines(for: data)
        }

        let logString = """

        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        OPERATION:
        \(String(describing: T.self))

        REQUEST:
        \(requestLines.joined(separator: " \\\n"))

        \(responseLines.joined(separator: "\n"))
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        """

        logger(logString)
    }

    private func lines(for response: HTTPResponse) -> [String] {
        var lines: [String] = []
        lines += ["Status: \(response.status)"]
        lines += response.headerFields
            .sorted { $0.name.canonicalName < $1.name.canonicalName }
            .map { "-H '\($0.name.canonicalName): \($0.value)'" }

        return lines
    }

    private func lines(for data: Data) -> [String] {
        if data.count > 0 {
            ["Body: \(String(data: data, encoding: .utf8).or("<empty>"))"]
        } else {
            ["Body: <empty>"]
        }
    }
}
