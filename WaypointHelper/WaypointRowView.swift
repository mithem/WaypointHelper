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
    @State private var distance = CLLocationDistance()
    
    var body: some View {
        HStack {
            Image(systemName: waypoint.type)
                .font(.system(size: 26, design: .rounded))
                .padding(.horizontal)
            Text(waypoint.name ?? "")
            Spacer()
            Text("\(distance)")
                .font(.system(.title3))
                .padding(.trailing)
        }
    }
}

struct WaypointRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WaypointRowView(waypoint: waypointsForPreviews[0])
            WaypointRowView(waypoint: waypointsForPreviews[1])
            WaypointRowView(waypoint: waypointsForPreviews[2])
        }
        .previewLayout(.fixed(width: 300, height: 80))
    }
}
