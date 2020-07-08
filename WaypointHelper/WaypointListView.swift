//
//  WaypointListView.swift
//  WaypointHelper
//
//  Created by Miguel Themann on 07.07.20.
//

import SwiftUI
import CoreLocation

struct WaypointListView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State var waypoints = [Waypoint]()
    @State private var showingAddWaypointView = false
    @State private var reversed = false
    @State private var resetBtnDisabled = true
    @State private var showResetWaypointsActionSheet = false
    @StateObject var locationManager = LocationManager()
    @State private var currentLocation: CLLocation?
    
    var body: some View {
        NavigationView {
            List {
                Text("Accuracy: \(formatDistance(distance: locationManager.trueAccuracy) ?? "unkown")")
                    .foregroundColor(.secondary)
                ForEach(waypoints) { waypoint in
                    NavigationLink(destination: WaypointMapView(waypoint: waypoint)) {
                        WaypointRowView(waypoint: waypoint, locationManager: locationManager)
                    }
                }
                .onDelete { offsets in
                        waypoints.remove(atOffsets: offsets)
                        saveWaypoints()
                }
                Button(action: {
                    showResetWaypointsActionSheet = true
                }) {
                    if resetBtnDisabled {
                        Text("Reset")
                            .foregroundColor(.secondary)
                    } else {
                        Text("Reset")
                            .foregroundColor(.red)
                    }
                }.disabled(resetBtnDisabled)
            }
            .onDisappear(perform: saveWaypoints)
            .navigationBarTitle("My waypoints")
            .navigationBarItems(leading: Button(action: {
                withAnimation {
                    reverseWaypoints()
                }
                getLocation()
            }) {
                if colorScheme == .dark {
                    Image(systemName: reversed ? "flag.slash.circle" : "flag.circle")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    Image(systemName: reversed ? "flag.slash.circle" : "flag.circle")
                        .foregroundColor(.black)
                        .padding()
                }
            },trailing: Button(action: {
                showingAddWaypointView = true
            }) {
                if colorScheme == .dark {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding()
                }
            })
            .onAppear(perform: loadWaypoints)
            .onAppear(perform: getLocation)
            .onAppear {
                locationManager.subscribe(self)
            }
            .actionSheet(isPresented: $showResetWaypointsActionSheet) {
                ActionSheet(title: Text("Reset waypoints?"), message: Text("This action cannot be undone."), buttons: [.destructive(Text("Reset")){resetWaypoints()}, .cancel()])
            }
        }
        .sheet(isPresented: $showingAddWaypointView) {
            AddWaypointView(delegate: self, locationManager: locationManager)
        }
    }
    
    func getLocation() {
        locationManager.requestLocation()
    }
    
    func resetWaypoints() {
        waypoints = []
        saveWaypoints()
    }
    
    func reverseWaypoints() {
        reversed.toggle()
        var new = [Waypoint]()
        for waypoint in waypoints.reversed() {
            new.append(Waypoint(type: waypointTypeOpposites[waypoint.type] ?? waypoint.type, name: waypoint.name))
        }
        waypoints = new
    }
    
    func loadWaypoints() {
        let ud = UserDefaults()
        let waypointsArr = (ud.array(forKey: "waypoints") ?? [Data]()) as! [Data]
        var myWaypoints = [Waypoint]()
        var waypoint: Waypoint?
        for data in waypointsArr {
            waypoint = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Waypoint.self, from: data)
            if let waypoint = waypoint {
                myWaypoints.append(waypoint)
            }
        }
        waypoints = myWaypoints
        if waypoints.count > 0 {
            resetBtnDisabled = false
        } else {
            resetBtnDisabled = true
        }
    }
    
    func saveWaypoints() {
        if waypoints.count == 0 {
            resetBtnDisabled = true
        } else {
            resetBtnDisabled = false
        }
        let ud = UserDefaults()
        let waypointsArr = waypoints.map { waypoint in try! NSKeyedArchiver.archivedData(withRootObject: waypoint, requiringSecureCoding: true) }
        ud.set(waypointsArr, forKey: "waypoints")
    }
}

extension WaypointListView: LocationManagerSubscriber {
    func didUpdateLocation() {
        currentLocation = locationManager.location
    }
}

extension WaypointListView: AddWaypointViewDelegate {
    func addWaypoint(waypoint: Waypoint) {
        waypoints.append(waypoint)
        resetBtnDisabled = false
        saveWaypoints()
    }
}

struct WaypointListView_Previews: PreviewProvider {
    static var previews: some View {
        WaypointListView(waypoints: waypointsForPreviews)
    }
}
