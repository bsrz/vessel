import Foundation

extension VesselOperation {

    /// The default encoder used by an operation
    public var encoder: JSONEncoder { VesselClient.encoder }

    /// The default decoder used by an operation
    public var decoder: JSONDecoder { VesselClient.decoder }
}

extension VesselOperation where Response: Decodable {

    /// Default decoding in cases where `Response` associated type is `Decodable`.
    public func handleResponse(_ response: Data) throws -> Response {
        try decoder.decode(Response.self, from: response)
    }
}

extension VesselOperation where Response == String {

    /// Default decoder in cases where `Response` associated type is a `String`.
    /// Always decodes to UTF8.
    public func handleResponse(_ response: Data) throws -> String {
        String(decoding: response, as: UTF8.self)
    }
}

extension VesselOperation where Response == Void {

    /// Default decoding  cases where there is no expected response.
    public func handleResponse(_ response: Data) throws { }
}
