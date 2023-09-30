import Foundation

extension VesselRequest {

    /// The default encoder used by an operation
    public var encoder: JSONEncoder { VesselClient.encoder }

    /// The default decoder used by an operation
    public var decoder: JSONDecoder { VesselClient.decoder }
}

extension VesselRequest where ResponseType: Decodable {

    /// Default decoding in cases where `ResponseType` associated type is ``Decodable``.
    public func handle(received: Data) throws -> ResponseType {
        try decoder.decode(ResponseType.self, from: received)
    }
}

extension VesselRequest where ResponseType == String {

    /// Default decoder in cases where ``ResponseType`` associated type is a ``String``.
    /// Always decodes to UTF8.
    public func handle(received: Data) throws -> String {
        String(decoding: received, as: UTF8.self)
    }
}

extension VesselRequest where ResponseType == Void {

    /// Default decoding  cases where there is no expected response.
    public func handle(received: Data) throws { }
}
