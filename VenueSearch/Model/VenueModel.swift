//
//  VenueModel.swift
//  VenueSearch
//
//  Created by Grzegorz Sowa on 25/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import Foundation

class VenueModel {
    let name: String
    var venueAddress: VenueLocationModel?
    
    enum VenueJSON: String {
        case name = "name"
        case location = "location"
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(dictionary: [String: Any]) {
        self.name = dictionary[VenueJSON.name.rawValue] as? String ?? ""
        
        if let locationDict = dictionary[VenueJSON.location.rawValue] as? [String: Any] {
            self.venueAddress = VenueLocationModel(locationDictionary: locationDict)
        }
    }
}

extension VenueModel: Equatable {
    static func ==(lhs: VenueModel, rhs: VenueModel) -> Bool {
        return lhs.name == rhs.name
            && lhs.venueAddress?.distance == rhs.venueAddress?.distance
            && lhs.venueAddress?.venueAddressToDisplay == rhs.venueAddress?.venueAddressToDisplay
    }
}
