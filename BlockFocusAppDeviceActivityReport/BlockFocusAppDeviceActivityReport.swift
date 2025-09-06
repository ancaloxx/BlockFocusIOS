//
//  BlockFocusAppDeviceActivityReport.swift
//  BlockFocusAppDeviceActivityReport
//
//  Created by ancalox on 05/09/25.
//

import DeviceActivity
import SwiftUI

@main
struct BlockFocusAppDeviceActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
