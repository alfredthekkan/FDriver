//
//  BackView.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 2/4/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit

@IBDesignable class BackView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        let im = UIImageView(frame: UIScreen.main.bounds)
        im.image = UIImage(named: "pattern")
        im.contentMode = .scaleAspectFill
        insertSubview(im, at: 0)
        im.backgroundColor = .red
    }

}
