//
//  models.swift
//  WaypointHelper
//
//  Created by Miguel Themann on 07.07.20.
//

import Foundation
import CoreLocation

class Waypoint: NSObject, NSSecureCoding, Identifiable {
    static var supportsSecureCoding = true
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(type, forKey: "type")
        coder.encode(location, forKey: "location")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String
        self.type = (coder.decodeObject(forKey: "type") as? String) ?? "arrow.up"
        self.location = coder.decodeObject(forKey: "location") as? CLLocation
    }
    
    let id = UUID()
    let name: String?
    var type: String
    let location: CLLocation?
    
    init(type: String, location: CLLocation? = nil, name: String? = nil) {
        self.name = name
        self.type = type
        self.location = location
    }
}
