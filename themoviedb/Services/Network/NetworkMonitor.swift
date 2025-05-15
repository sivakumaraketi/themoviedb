//
//  NetworkMonitor.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Network
import Combine

/// Enum for common networking errors, conforming to Error and LocalizedError for better error handling.
enum ConnectionType: String {
    case wifi = "WiFi"
    case cellular = "Cellular"
    case ethernet = "Ethernet"
    case unknown = "Unknown"
    case disconnected = "Disconnected"
}

/// Handles HTTP requests and decodes JSON responses into Swift models.
/// Uses Swift concurrency (async/await) for asynchronous networking.
final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    // Reactive publisher
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var connectionType: ConnectionType = .unknown
    
    // For callback when connection is restored
    private var onConnectionRestored: (() -> Void)?

    var connectionRestoredCancellable: AnyCancellable?

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.connectionType = self?.getConnectionType(from: path) ?? .unknown

            // If connection was restored, trigger callback once
            if path.status == .satisfied {
                self?.onConnectionRestored?()
                self?.onConnectionRestored = nil
            }
        }
        monitor.start(queue: queue)
    }
    
    /// Assigns a callback to be executed once internet is back
    func waitForConnection(_ callback: @escaping () -> Void) {
        if isConnected {
            callback()
        } else {
            onConnectionRestored = callback
        }
    }

    /// Public Combine publisher for observing changes
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        $isConnected.removeDuplicates().eraseToAnyPublisher()
    }

    /// Detects the connection type
    private func getConnectionType(from path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.status == .unsatisfied {
            return .disconnected
        } else {
            return .unknown
        }
    }
}
