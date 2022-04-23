//
//  CustomLabel.swift
//  Plant Recognition
//
//  Created by Mohammad Hamudeh on 23/04/2022.
//

import UIKit
@IBDesignable

class CustomLabel: UILabel {
    @IBInspectable var masked : Bool = false
        
    override func awakeFromNib() {
        layer.cornerRadius = 5
        if masked{
            layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
