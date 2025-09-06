//
//  CustomButton.swift
//  BlockFocusApp
//
//  Created by ancalox on 04/09/25.
//

import UIKit

class CustomButton: UIButton {
    
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    
}
