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
        guard let loc = location else { coder.encode(["lat": nil, "long": nil], forKey: "location"); return}
        let locDict = ["lat": loc.coordinate.latitude, "long": loc.coordinate.longitude]
        coder.encode(locDict, forKey: "location")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String
        self.type = (coder.decodeObject(forKey: "type") as? String) ?? "arrow.up"
        let locDict = (coder.decodeObject(forKey: "location") as? Dictionary<String, Double?>) ?? ["lat": nil, "long": nil]
        let myLatitude = locDict["lat"]
        let myLongitude = locDict["long"]
        self.location = nil
        guard let latitude = myLatitude else { return }
        guard let longitude = myLongitude else { return }
        guard let lat = latitude else { return }
        guard let long = longitude else { return }
        self.location = CLLocation(latitude: lat, longitude: long)
    }
    
    let id = UUID()
    let name: String?
    var type: String
    var location: CLLocation?
    
    init(type: String, location: CLLocation? = nil, name: String? = nil) {
        self.name = name
        self.type = type
        self.location = location
    }
}
