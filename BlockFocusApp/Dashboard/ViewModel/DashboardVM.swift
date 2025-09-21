//
//  DashboardVM.swift
//  BlockFocusApp
//
//  Created by ancalox on 05/09/25.
//

import FamilyControls
import Foundation
import DeviceActivity

class DashboardVM: ObservableObject {
    
    @Published var selection = FamilyActivitySelection()
    @Published var scaleAnimate = false
    @Published var targetCenter: CGPoint = .zero
    
    var listBundle = [String]()
    var timeInterval: Double = 3600
    var setTimeInterval: Double = 3600
    var isShield = false
    var isStopEarly = false
    
    init() {
//        timeInterval = Constants.userDefaults?.double(forKey: "timeInterval") ?? 0
        setTimeInterval = Constants.userDefaults?.double(forKey: "setTimeInterval") ?? 0
        
        getSelectionStorage()
    }
    
    func updateApplicationSelections() {
        listBundle = selection.applications.map { $0.bundleIdentifier ?? "" }
        
        if let data = try? JSONEncoder().encode(selection) {
            Constants.userDefaults?.set(data, forKey: "applications")
        }
    }
    
    func startShield() {
        let calendar = Calendar.current
        let now = Date.now
        let end = now.addingTimeInterval(timeInterval)
        
        let startComponents = calendar.dateComponents([.hour, .minute],
                                                      from: now)
        
        let endComponents = calendar.dateComponents([.hour, .minute],
                                                    from: end)
        
        let schedule = DeviceActivitySchedule(intervalStart: startComponents,
                                              intervalEnd: endComponents,
                                              repeats: true)
        
        do {
            try DeviceActivityCenter().startMonitoring(Constants.deviceActivityName,
                                                       during: schedule)
            
            Constants.userDefaults?.set(timeInterval, forKey: "timeInterval")
            Constants.userDefaults?.set(timeInterval, forKey: "setTimeInterval")
            
            print("block with monitoring success")
        } catch {
            print("block failed: \(error.localizedDescription)")
        }
    }
    
    func stopShield() {
        DeviceActivityCenter().stopMonitoring([Constants.deviceActivityName])
    }
    
    func diffTimeInterval() -> Double {
        timeInterval = Constants.userDefaults?.double(forKey: "timeInterval") ?? 0
        setTimeInterval = Constants.userDefaults?.double(forKey: "setTimeInterval") ?? 0
        
        let diff = timeInterval - setTimeInterval
        return diff
    }
    
    func getSelectionStorage() {
        if let data = Constants.userDefaults?.data(forKey: "applications"),
           let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            self.selection = selection
        }
    }
    
}
