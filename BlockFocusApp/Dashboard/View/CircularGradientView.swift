//
//  CircularGradientView.swift
//  BlockFocusApp
//
//  Created by ancalox on 21/09/25.
//

import SwiftUI

struct CircularGradientView: View {
    
    @State private var animate = false
    
    @ObservedObject var viewModel: DashboardVM
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.green, .yellow, .pink, .cyan, .blue, .purple]),
                        startPoint: animate ? .topLeading : .bottomLeading,
                        endPoint: animate ? .bottomTrailing : .topTrailing
                    )
                )
                .frame(
                    width: viewModel.scaleAnimate ? 260 : 90,
                    height: viewModel.scaleAnimate ? 260 : 90
                )
                .blur(radius: 8)
                .animation(
                    .easeOut(duration: 2),
                    value: viewModel.scaleAnimate
                )
                .onAppear {
                    withAnimation(
                        .linear(duration: 3)
                        .repeatForever(autoreverses: true)
                    ) {
                        animate.toggle()
                    }
                }

            Circle()
                .fill(
                    .back
                )
                .frame(
                    width: viewModel.scaleAnimate ? 245 : 75,
                    height: viewModel.scaleAnimate ? 245 : 75
                )
                .shadow(
                    color: Color.white,
                    radius: 1,
                    x: 0,
                    y: 0
                )
                .animation(
                    .easeOut(duration: 2),
                    value: viewModel.scaleAnimate
                )
            
            Image(systemName: "lock.fill")
                .foregroundColor(Color.gray.opacity(0.8))
                .font(.system(size: 40))
                .offset(y: viewModel.scaleAnimate ? 0 : -90)
                .opacity(viewModel.scaleAnimate ? 1 : 0)
                .animation(
                    .easeOut(duration: 1),
                    value: viewModel.scaleAnimate
                )
        }
    }
}
