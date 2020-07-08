
//  constants.swift
//  WaypointHelper
//
//  Created by Miguel Themann on 07.07.20.
//

import Foundation
import CoreLocation

let waypointsForPreviews = [Waypoint(type: "arrow.up", location: CLLocation(), name: "Kreisverkehr"), Waypoint(type: "arrow.turn.up.left", location: CLLocation()), Waypoint(type: "arrow.turn.up.right", location: CLLocation(), name: "großer Baum")]

let waypointTypes = ["arrow.up", "arrow.turn.up.left", "arrow.turn.up.right"]

let waypointTypeOpposites = [
    "arrow.up": "arrow.up",
    "arrow.turn.up.left": "arrow.turn.up.right",
    "arrow.turn.up.right": "arrow.turn.up.left"
]
