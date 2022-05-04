@testable import Vessel
import XCTest

class VesselClientTests: XCTestCase {
    func test0() async throws {
        let client = VesselClient(
            behaviours: [
                BaseUrlVesselBehaviour.randomUser,
                LoggingVesselBehaviour(),
                StatusCodeVesselBehaviour(accepted: 200..<300)
            ]
        )

        try await client.perform(RandomUserOperation())
    }
}
