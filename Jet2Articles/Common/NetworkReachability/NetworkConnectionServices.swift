//
//  NetworkConnectionServices.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 10/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import Reachability


class NetworkConnectionServices {
    
    static let shared = NetworkConnectionServices()
    
    private let reachability: Reachability
    private let notificationCenter: NotificationCenter
    
    enum NotificationName {
        static let networkConnectionDown = NSNotification.Name(rawValue: "networkConnectionDownNotification")
        static let networkConnectionUp = NSNotification.Name(rawValue: "networkConnectionUpNotification")
    }
    
    init(reachability: Reachability = try! Reachability(),
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.reachability = reachability
        self.notificationCenter = notificationCenter
    }
    
    func startMonitoring() {
        reachability.whenReachable = { [weak self] reachability in
            guard let strongSelf = self else { return }
            
            strongSelf.postInternetConnectionUpNotification()
        }
        
        reachability.whenUnreachable = { [weak self] reachability in
            guard let strongSelf = self else { return }
            
            strongSelf.postInternetConnectionDownNotification()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("ERROR: Could not start reachability notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
    }
    
    func isNetworkReachable() -> Bool {
        return reachability.connection != .unavailable
    }
    
    private func postInternetConnectionDownNotification() {
        print("INFO: Connection down")
        notificationCenter.post(name: NotificationName.networkConnectionDown, object: self)
    }
    
    private func postInternetConnectionUpNotification() {
        print("INFO: Connection up")
        notificationCenter.post(name: NotificationName.networkConnectionUp, object: self)
    }
    
    func subscribeToInternetConnectionNotificationsWith(observer: AnyObject, connectionUp: Selector?, connectionDown: Selector?) {
        if let connectionUpSelector = connectionUp {
            notificationCenter.addObserver(observer,
                                           selector: connectionUpSelector,
                                           name: NotificationName.networkConnectionUp,
                                           object: nil)
        }
        
        if let connectionDownSelector = connectionDown {
            notificationCenter.addObserver(observer,
                                           selector: connectionDownSelector,
                                           name: NotificationName.networkConnectionDown,
                                           object: nil)
        }
    }
    
    func removeInternetConnectionNotificationsWithObserver(observer: AnyObject) {
        notificationCenter.removeObserver(observer)
    }
    
}
