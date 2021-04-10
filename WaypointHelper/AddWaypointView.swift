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
    let locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            Form {
                TextField("name", text: $name)
                WaypointLocationInlineView(location: location)
                ScrollView([.horizontal, .vertical]) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            WaypointTypeImage(type: "arrow.up", delegate: self)
                                .padding(10)
                            WaypointTypeImage(type: "arrow.turn.up.left", delegate: self)
                                .padding(10)
                            WaypointTypeImage(type: "arrow.turn.up.right", delegate: self)
                                .padding(10)
                            WaypointTypeImage(type: "arrow.up.left", delegate: self)
                                .padding(10)
                            WaypointTypeImage(type: "arrow.up.right", delegate: self)
                                .padding(10)
                            WaypointTypeImage(type: "arrow.uturn.down", delegate: self)
                                .padding(10)
                        }
                        HStack {
                            WaypointTypeImage(type: "mappin", delegate: self)
                                .padding(10)
                            WaypointTypeImage(type: "flag", delegate: self)
                                .padding(10)
                        }
                    }
                }
            }
            .onAppear(perform: getLocation)
            .navigationTitle("New Waypoint")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func getLocation() {
        locationManager.requestLocation()
        location = locationManager.location
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
            .padding(50)
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

struct WaypointLocationInlineView: View {
    
    let location: CLLocation?
    
    var body: some View {
        Group {
            if location != nil {
                HStack {
                    Image(systemName: "location")
                    Text("Accuracy: \(formatDistance(location?.horizontalAccuracy) ?? "unknown")")
                }
            } else {
                HStack {
                    Image(systemName: "location.slash")
                    Text("Location unavailable.")
                }
            }
        }
    }
}

protocol AddWaypointViewDelegate {
    func addWaypoint(waypoint: Waypoint)
}

struct AddWaypointView_Previews: PreviewProvider {
    static var previews: some View {
        AddWaypointView(delegate: self as! AddWaypointViewDelegate, locationManager: LocationManager())
    }
}

extension AddWaypointView_Previews: AddWaypointViewDelegate {
    func addWaypoint(waypoint: Waypoint) {}
}
