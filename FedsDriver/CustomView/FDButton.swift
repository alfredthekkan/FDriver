//
//  FDButton.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 2/3/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit

@IBDesignable public class FDButton: UIButton {
    
    let color = UIColor(red: 30/255.0, green: 97/255, blue: 218/255.0, alpha: 1.0).cgColor
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * bounds.size.height
        layer.backgroundColor = color
        clipsToBounds = true
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = UIFont(name: "Junegull", size: 24.0)
    }
    override public var isEnabled: Bool {
        didSet {
            if isEnabled {
                layer.backgroundColor = color
            }else{
                layer.backgroundColor = UIColor.lightGray.cgColor
            }
        }
    }
    
}
