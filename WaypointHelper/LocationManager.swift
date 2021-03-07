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
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        trueAccuracy = location!.horizontalAccuracy
        courseAccuracy = location!.courseAccuracy
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
}
