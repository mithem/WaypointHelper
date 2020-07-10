//
//  shared.swift
//  WaypointHelper
//
//  Created by Miguel Themann on 08.07.20.
//

import Foundation
import CoreLocation
import SwiftUI

func formatDistance(_ distance: CLLocationDistance?) -> String? {
    guard let distance = distance else { return nil }
    let s = "\(round(distance * 100.0) / 100.0)m"
    if s == "nanm" {
        return nil
    } else {
        return s
    }
}

func formatAccuracy(distance: CLLocationDistance?, course: CLLocationDirectionAccuracy) -> String {
    let ds: String? = formatDistance(distance)
    var cs: String? = "\(round(course * 100.0) / 100.0)deg"
    if cs?.lowercased() == "nandeg" {
        cs = nil
    }
    return "\(ds ?? "unkown") @ \(cs ?? "unkown")"
}

func getHeading(l1: CLLocation?, l2: CLLocation?) -> Angle? {
    // https://www.igismap.com/formula-to-find-bearing-or-heading-angle-between-two-points-latitude-longitude/
    
    guard let l1 = l1 else { return nil }
    guard let l2 = l2 else { return nil }
    
    let latA = l1.coordinate.latitude
    let latB = l2.coordinate.latitude
    
    let longA = l1.coordinate.longitude
    let longB = l2.coordinate.longitude
    
    let deltaLong = abs(longA - longB)
    
    let cosLatB = cos(latB)
    
    let x = cosLatB * sin(deltaLong)
    let y = cos(latB) * sin(latB) - (sin(latA) * cos(latB) * cos(deltaLong))
    
    return Angle(radians: atan2(x, y))
}
