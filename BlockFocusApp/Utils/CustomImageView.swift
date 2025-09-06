//
//  CustomImageView.swift
//  BlockFocusApp
//
//  Created by ancalox on 05/09/25.
//

import UIKit

class CustomImageView: UIImageView {
    
    @IBInspectable var tint: UIColor = UIColor.white {
        didSet {
            image = image?.withRenderingMode(.alwaysTemplate)
            tintColor = tint
        }
    }
    
}
