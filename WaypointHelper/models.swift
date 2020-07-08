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
        coder.encode(latitude, forKey: "latitude")
        coder.encode(longitude, forKey: "longitude")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String
        self.type = (coder.decodeObject(forKey: "type") as? String) ?? "arrow.up"
        self.latitude = coder.decodeObject(forKey: "latitude") as? Double
        self.longitude = coder.decodeObject(forKey: "longitude") as? Double
        guard let lat = latitude else { return }
        guard let long = longitude else { return }
        location = CLLocation(latitude: lat, longitude: long)
    }
    
    let id = UUID()
    let name: String?
    var type: String
    var location: CLLocation?
    var latitude: Double?
    var longitude: Double?
    
    init(type: String, location: CLLocation? = nil, name: String? = nil) {
        self.name = name
        self.type = type
        guard let loc = location else { return }
        self.location = loc
        latitude = loc.coordinate.latitude
        longitude = loc.coordinate.longitude
    }
}
