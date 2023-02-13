//
//  NetworkMonitor.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 06/02/2023.
//

import Foundation
import Network

enum ConnectionType {
    case wifi
    case cellular
    case loopback
    case wiredEthernet
    case other
}

class NetWorkMonitor {
    static let shared = NetWorkMonitor()
    let queue = DispatchQueue.global()
    private var monitor: NWPathMonitor
    private(set) var connectionType: ConnectionType = .other
    public private(set) var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {[unowned self] path in
            isConnected = path.status == .satisfied
            getConnectionType(path)
        }
    }

    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.loopback) {
            connectionType = .loopback
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .wiredEthernet
        } else {
            connectionType = .other
        }
    }

    private func stopMonitoring() {
        monitor.cancel()
    }
}
