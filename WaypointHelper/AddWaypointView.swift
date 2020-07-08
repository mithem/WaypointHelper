//
//  AddWaypointView.swift
//  WaypointHelper
//
//  Created by Miguel Themann on 07.07.20.
//

import SwiftUI
import CoreLocation

struct AddWaypointView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let delegate: AddWaypointViewDelegate
    @State private var location: CLLocation?
    @State private var name = ""
    //@StateObject private var manager = LocationManager()
    
    var body: some View {
        Form {
            TextField("name", text: $name)
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        WaypointTypeImage(type: "arrow.up", delegate: self)
                        WaypointTypeImage(type: "arrow.turn.up.left", delegate: self)
                        WaypointTypeImage(type: "arrow.turn.up.right", delegate: self)
                    }
                }
            }
        }
        //.onAppear(perform: getLocation)
    }
    
    func getLocation() {
//        manager.requestLocation()
//        location = manager.location
    }
}

extension AddWaypointView: WaypointTypeImageDelegate {
    func selected(_ type: String) {
        let waypoint = Waypoint(type: type, location: location, name: name)
        delegate.addWaypoint(waypoint: waypoint)
        presentationMode.wrappedValue.dismiss()
    }
}

struct WaypointTypeImage: View {
    
    let type: String
    let delegate: WaypointTypeImageDelegate
    
    var body: some View {
        Image(systemName: type)
            .font(.system(size: 26))
            .padding()
            .background(Color.gray.opacity(0.4))
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                delegate.selected(type)
            }
    }
}

protocol WaypointTypeImageDelegate {
    func selected(_ type: String)
}

protocol AddWaypointViewDelegate {
    func addWaypoint(waypoint: Waypoint)
}

struct AddWaypointView_Previews: PreviewProvider {
    static var previews: some View {
        AddWaypointView(delegate: self as! AddWaypointViewDelegate)
    }
}

extension AddWaypointView_Previews: AddWaypointViewDelegate {
    func addWaypoint(waypoint: Waypoint) {}
}
