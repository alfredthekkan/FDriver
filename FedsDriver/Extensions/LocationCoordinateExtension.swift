//
//  LocationCoordinateExtension.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/21/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func values() -> [String: Double] {
        return ["driver_lat":latitude, "driver_ing":longitude]
    }
}
