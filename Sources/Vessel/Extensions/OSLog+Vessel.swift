import os.log

extension OSLog {

    /// A default logger for the `LoggingVesselBehaviour` if none is provided
    static let vessel = OSLog(
        subsystem: "io.srz.vessel",
        category: "NETWORKING ☁️"
    )
}
