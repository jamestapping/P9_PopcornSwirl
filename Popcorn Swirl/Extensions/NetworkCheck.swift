//
//  NetMonitor.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 27/09/2021.
//

import Network

protocol NetworkCheckDelegate {
    func statusDidChange(status: NWPath.Status)
}

class NetworkCheck {

    var monitor = NWPathMonitor()

    static let _sharedInstance = NetworkCheck()

    var networkCheckDelegate: NetworkCheckDelegate?

    class func sharedInstance() -> NetworkCheck {
        return _sharedInstance
    }

    // Create only one instance of NetworkCheck
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async(execute: {
                self.networkCheckDelegate?.statusDidChange(status: path.status)
            })
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }

    func removeMonitoring() {
        monitor.cancel()
    }
}
