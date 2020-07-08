//
//  WaypointRowView.swift
//  WaypointHelper
//
//  Created by Miguel Themann on 07.07.20.
//

import SwiftUI
import CoreLocation

struct WaypointRowView: View {
    
    let waypoint: Waypoint
    @StateObject var locationManager: LocationManager
    @State private var distance: CLLocationDistance?
    @State private var formattedDistance = ""
    
    var body: some View {
        HStack {
            Image(systemName: waypoint.type)
                .font(.system(size: 26, design: .rounded))
                .padding(.trailing)
            Text(waypoint.name ?? "")
            Spacer()
            if distance != nil {
                Text(formattedDistance)
                    .font(.system(.title3))
                    .padding(.leading)
            } else {
                Image(systemName: "location.slash")
            }
        }
        .onAppear {
            locationManager.subscribe(self)
        }
    }
    
    func getDistance() {
        guard let loc = locationManager.location else { distance = nil; return }
        distance = waypoint.location?.distance(from: loc)
        formattedDistance = formatDistance(distance: distance) ?? ""
    }
}

extension WaypointRowView: LocationManagerSubscriber {
    func didUpdateLocation() {
        getDistance()
    }
}

struct WaypointRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            WaypointRowView(waypoint: waypointsForPreviews[0], locationManager: LocationManager())
            WaypointRowView(waypoint: waypointsForPreviews[1], locationManager: LocationManager())
            WaypointRowView(waypoint: waypointsForPreviews[2], locationManager: LocationManager())
        }
        .previewLayout(.fixed(width: 350, height: 240))
    }
}
