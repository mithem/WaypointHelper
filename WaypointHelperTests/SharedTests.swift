//
//  SharedTests.swift
//  WaypointHelperTests
//
//  Created by Miguel Themann on 10.07.20.
//

import XCTest
import CoreLocation
@testable import WaypointHelper

class SharedTests: XCTestCase {
    func testSwitzerland() throws {
        let l1 = CLLocation(latitude: 46.1672, longitude: 8.8772)
        let l2 = CLLocation(latitude: 47.5236, longitude: 9.0036)
        
        var angle = getHeading(l1: l1, l2: l2)
        XCTAssert(angle.degrees > -6 && angle.degrees < -5.997)
        
        angle = getHeading(l1: l2, l2: l1)
        XCTAssert(angle.degrees > -174.02 && angle.degrees < -174)
    }
//    
//    func testVietnam() throws {
//        let l1 = CLLocation(latitude: 13.9753, longitude: 107.9979)
//        let l2 = CLLocation(latitude: 13.7702, longitude: 109.2685)
//        
//        var angle = getHeading(l1: l1, l2: l2)
//        XCTAssert(angle.degrees > -120 && angle.degrees < -90)
//        
//        angle = getHeading(l1: l2, l2: l1)
//        //XCTAssert(angle.degrees)
//    }
}
