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
    @State private var showingResetWaypointsActionSheet = false
    @StateObject var locationManager = LocationManager()
    @State private var currentLocation: CLLocation?
    @State private var waypointChanged = false
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    getLocation()
                }) {
                    Text("Accuracy: \(formatAccuracy(distance: locationManager.trueAccuracy, course: locationManager.courseAccuracy))")
                        .foregroundColor(.secondary)
                }
                ForEach(waypoints) { waypoint in
                    HStack {
                        Image(systemName: waypoint.type)
                            .font(.system(size: 26, design: .rounded))
                            .padding(.trailing)
                            .onTapGesture {
                                waypoint.disabled.toggle()
                                saveWaypoints()
                                waypointChanged.toggle()
                            }
                        Text(waypoint.name ?? "")
                            .onTapGesture {
                                waypoint.disabled.toggle()
                                saveWaypoints()
                                waypointChanged.toggle()
                            }
                        Spacer()
                        if let distance = getDistance(for: waypoint.location) {
                            Text(formatDistance(distance) ?? "unknown")
                                .font(.system(.title3))
                                .padding(.leading)
                            Image(systemName: "location.circle")
                                .rotationEffect(Angle(degrees: locationManager.location?.course ?? 0) - (getHeading(l1: locationManager.location, l2: waypoint.location) ?? Angle()))
                        } else {
                            Image(systemName: "location.slash")
                        }
                        if waypointChanged {} // doesn't feel too good..
                    }
                    .foregroundColor(waypoint.disabled ? Color.secondary : (colorScheme == .dark ? Color.white : .black))
                    .transition(.opacity)
                }
                .onDelete { offsets in
                    waypoints.remove(atOffsets: offsets)
                    saveWaypoints()
                }
                Button(action: {
                    showingResetWaypointsActionSheet = true
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
                withAnimation() {
                    reverseWaypoints()
                }
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
            .actionSheet(isPresented: $showingResetWaypointsActionSheet) {
                ActionSheet(title: Text("Reset waypoints?"), message: Text("This action cannot be undone."), buttons: [.destructive(Text("Reset")){resetWaypoints()}, .cancel()])
            }
        }
        .sheet(isPresented: $showingAddWaypointView) {
            AddWaypointView(delegate: self, locationManager: locationManager)
        }
    }
    
    func getDistance(for location: CLLocation?) -> CLLocationDistance? {
        guard let loc = locationManager.location else { return nil }
        return location?.distance(from: loc)
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
        for waypoint in waypoints {
            waypoint.type = waypointTypeOpposites[waypoint.type] ?? waypoint.type
        }
        waypoints.reverse()
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
