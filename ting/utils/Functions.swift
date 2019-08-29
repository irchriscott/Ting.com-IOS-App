//
//  Functions.swift
//  ting
//
//  Created by Ir Christian Scott on 07/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import SystemConfiguration

class Functions : NSObject {
    
    override init() {
        super.init()
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    class func isConnectedToInternet() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress){
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1){ zeroSocketAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSocketAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags){
            return false
        }
        
        let isReachable = flags.rawValue & UInt32(kSCNetworkFlagsReachable) != 0
        let needsConnection = flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired) != 0
        
        return isReachable && !needsConnection
    }
}
