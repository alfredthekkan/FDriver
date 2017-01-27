//
//  DeviceInfo.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/21/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import UIKit

struct DeviceInfo {
    static var id = UIDevice.current.identifierForVendor!.uuidString
    static var model = "iOS"
    
    static var values = ["device_id": DeviceInfo.id, "device_type":DeviceInfo.model]
}
