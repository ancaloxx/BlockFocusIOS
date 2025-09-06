//
//  ChooseTimeVM.swift
//  BlockFocusApp
//
//  Created by ancalox on 04/09/25.
//

class ChooseTimeVM {
    
    var times = [Int]()
    var timeSelected = 1
    
    init() {
        getTimes()
    }
    
    func getTimes() {
        times = [Int]()
        
        for i in 0..<24 {
            let time = i + 1
            times.append(time)
        }
    }
    
}
