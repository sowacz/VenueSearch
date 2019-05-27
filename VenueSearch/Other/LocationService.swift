//
//  LocationService.swift
//  VenueSearch
//
//  Created by Grzegorz Sowa on 26/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationPoint {
    var latitude: String
    var longitude: String
    
    var foursquareLocationValue: String {
        return latitude+","+longitude
    }
}

protocol LocationServiceDelegate: NSObjectProtocol {
    func locationUpdated(locationPoint: LocationPoint)
}

class LocationService: NSObject {
    
    private let locationManager: CLLocationManager
    
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
    }
    
    public func startReceivingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationObj = locations.last {
            self.delegate?.locationUpdated(locationPoint: LocationPoint(latitude: String(locationObj.coordinate.latitude), longitude: String(locationObj.coordinate.longitude)))
        }
    }
    
}
