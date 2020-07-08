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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(waypoints) { waypoint in
                    WaypointRowView(waypoint: waypoint)
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
                reverseWaypoints()
            }) {
                if colorScheme == .dark {
                    Image(systemName: reversed ? "flag.slash.circle" : "flag.circle")
                        .foregroundColor(.white)
                } else {
                    Image(systemName: reversed ? "flag.slash.circle" : "flag.circle")
                        .foregroundColor(.black)
                }
            },trailing: Button(action: {
                showingAddWaypointView = true
            }) {
                if colorScheme == .dark {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
                
            })
            .onAppear(perform: loadWaypoints)
            .actionSheet(isPresented: $showResetWaypointsActionSheet) {
                ActionSheet(title: Text("Reset waypoints?"), message: Text("This action cannot be undone."), buttons: [.destructive(Text("Reset")){resetWaypoints()}, .cancel()])
            }
        }
        .sheet(isPresented: $showingAddWaypointView) {
            AddWaypointView(delegate: self)
        }
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
