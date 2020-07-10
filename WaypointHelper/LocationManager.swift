//
//  LocationManager.swift
//  WaypointHelper
//
//  Created by Miguel Themann on 07.07.20.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var accuracyAuthorization: CLAccuracyAuthorization
    @Published var trueAccuracy: CLLocationAccuracy
    @Published var courseAccuracy: CLLocationDirectionAccuracy
    
    override init() {
        authorizationStatus = .notDetermined
        accuracyAuthorization = locationManager.accuracyAuthorization
        trueAccuracy = .nan
        courseAccuracy = .nan
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        trueAccuracy = location!.horizontalAccuracy
        courseAccuracy = location!.courseAccuracy
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus()
        
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
            requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
