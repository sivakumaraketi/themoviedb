//
//  NetworkMonitor.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Network
import Combine

//For checking network(wifi/celluar/no connection) status
final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
}
