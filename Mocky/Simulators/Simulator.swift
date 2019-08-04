import Foundation

// MARK: - Empty
struct Empty: Codable {
    let devices: [String: [Device]]
}

// MARK: - Device
struct Device: Codable {
    let state: State
    let isAvailable: Bool
    let name, udid: String
}

enum State: String, Codable {
    case booted = "Booted"
    case shutdown = "Shutdown"
}
