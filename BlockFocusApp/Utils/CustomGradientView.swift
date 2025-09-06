//
//  CustomGradientView.swift
//  BlockFocusApp
//
//  Created by ancalox on 04/09/25.
//

import UIKit

class CustomGradientView: UIView {
    
    @IBInspectable var oneColor: UIColor = UIColor.clear {
        didSet {
            setupGradientColors()
        }
    }
    
    @IBInspectable var twoColor: UIColor = UIColor.clear {
        didSet {
            setupGradientColors()
        }
    }
    
    @IBInspectable var threeColor: UIColor = UIColor.clear {
        didSet {
            setupGradientColors()
        }
    }
    
    @IBInspectable var fourColor: UIColor = UIColor.clear {
        didSet {
            setupGradientColors()
        }
    }
    
    @IBInspectable var fiveColor: UIColor = UIColor.clear {
        didSet {
            setupGradientColors()
        }
    }
    
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    
    var gradient = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.frame = bounds
        
        let circlePath = UIBezierPath(ovalIn: bounds)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        gradient.mask = shapeLayer
        
        gradient.filters = [
            CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 100]) as Any
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupGradientColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupGradientColors()
    }
    
    private func setupGradientColors() {
        gradient.removeFromSuperlayer()
        
        gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            oneColor.cgColor, twoColor.cgColor, threeColor.cgColor,
            fourColor.cgColor, fiveColor.cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradient)
    }
    
}
