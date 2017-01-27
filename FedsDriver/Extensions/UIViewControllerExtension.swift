//
//  UIViewControllerExtension.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/21/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var defaultStoryBoardIdentifier: String? {
        if let templates = value(forKey: "storyboardSegueTemplates") as! [AnyObject]? {
            if let id = templates.first?.value(forKey: "identifier") as? String {
                return id
            }
        }
        return nil
    }
}
