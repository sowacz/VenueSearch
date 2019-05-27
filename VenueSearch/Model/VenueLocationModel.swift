//
//  VenueAddressModel.swift
//  VenueSearch
//
//  Created by Grzegorz Sowa on 26/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import Foundation

class VenueLocationModel {
    let formattedAddress: [String]
    var distance: Int?
    
    var venueAddressToDisplay: String {
        if formattedAddress.count == 0 {
            return "Address: no info"
        } else {
            var result = ""
            var i = 0
            for addressEntry in formattedAddress {
                result += addressEntry
                i += 1
                if i >= 2 || i >= formattedAddress.count {
                    break
                }
                result += "\n"
            }
            return result
        }
    }
    
    var venueDistanceToDisplay: String {
        if let distance = distance {
            return "Dist. " + String(distance) + " m"
        } else {
            return "No information"
        }
    }
    
    enum VenueLocationJSON: String {
        case formattedAddress = "formattedAddress"
        case distance = "distance"
    }
    
    init(locationDictionary: [String: Any]) {
        self.formattedAddress = locationDictionary[VenueLocationJSON.formattedAddress.rawValue] as? [String] ?? [String]()
        self.distance = locationDictionary[VenueLocationJSON.distance.rawValue] as? Int
    }
    
    init(address: [String], distance: Int) {
        self.formattedAddress = address
        self.distance = distance
    }
}
