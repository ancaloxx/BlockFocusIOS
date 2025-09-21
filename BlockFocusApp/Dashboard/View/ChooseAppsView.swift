//
//  ChooseAppsView.swift
//  BlockFocusApp
//
//  Created by ancalox on 06/09/25.
//

import SwiftUI
import FamilyControls

struct ChooseAppsView: View {
    @ObservedObject var viewModel: DashboardVM
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
//            if viewModel.animateToCenter {
//                ZStack {
//                    ForEach(Array(viewModel.selection.applications), id: \.self) { item in
//                        Label(item.token!).labelStyle(.iconOnly)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
//            } else {
//                HStack(spacing: 4) {
//                    ForEach(Array(viewModel.selection.applications), id: \.self) { item in
//                        Label(item.token!).labelStyle(.iconOnly)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
            
            HStack(spacing: 4) {
                ForEach(Array(viewModel.selection.applications), id: \.self) { item in
                    ZStack {
                        Label(item.token!).labelStyle(.iconOnly)
                            .scaleEffect(x: 1.7, y: 1.7)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//#Preview {
//    ChooseAppsView()
//}
