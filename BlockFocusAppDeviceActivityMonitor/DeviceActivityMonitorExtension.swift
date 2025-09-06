//
//  DeviceActivityMonitorExtension.swift
//  BlockFocusAppDeviceActivityMonitor
//
//  Created by ancalox on 05/09/25.
//

import DeviceActivity
import Foundation
import ManagedSettings
import FamilyControls

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
        let userDefaults = UserDefaults(suiteName: "group.com.lox.BlockFocusApp.ShieldExt")
        let applications = userDefaults?.data(forKey: "applications") ?? Data()
        
        guard let selection = try? JSONDecoder().decode(FamilyActivitySelection.self,
                                                        from: applications) else {
            return
        }
        
        if !selection.applicationTokens.isEmpty {
            let tokens = selection.applicationTokens.map { $0 }
            store.shield.applications = Set(tokens)
        } else if !selection.categoryTokens.isEmpty {
            store.shield.applicationCategories = .specific(selection.categoryTokens)
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.clearAllSettings()
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
