//
//  Constants.swift
//  BlockFocusApp
//
//  Created by ancalox on 04/09/25.
//

import UIKit
import DeviceActivity

class Constants {
    
    static let DashboardStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    static let userDefaults = UserDefaults(suiteName: "group.in.appsquare.FocusApp.shieldExt")
    
    static let deviceActivityName = DeviceActivityName("FocusLock")
    
    static let bubbleItems: [String] = [
        "You are getting distracted again...",
        "Focus...",
        ""
    ]
    
}
