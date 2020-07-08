//
//  shared.swift
//  WaypointHelper
//
//  Created by Miguel Themann on 08.07.20.
//

import Foundation
import CoreLocation

func formatDistance(distance: CLLocationDistance?) -> String? {
    guard let distance = distance else { return nil }
    let s = "\(round(distance * 100.0) / 100.0)m"
    if s == "nanm" {
        return nil
    } else {
        return s
    }
}
