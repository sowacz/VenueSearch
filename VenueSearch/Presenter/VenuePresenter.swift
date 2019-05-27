//
//  VenuePresenter.swift
//  VenueSearch
//
//  Created by Grzegorz Sowa on 25/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import Foundation

struct VenueViewData {
    let name: String
    let address: String
    let distance: String
}

extension VenueViewData: Equatable {
    static func ==(lhs: VenueViewData, rhs: VenueViewData) -> Bool {
        return lhs.name == rhs.name
            && lhs.address == rhs.address
            && lhs.distance == rhs.distance
    }
}

protocol VenueView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setVenues(venues: [VenueViewData])
}

class VenuePresenter: NSObject {
    
    unowned private var venueView: VenueView
    private var foursquareService: FoursquareService
    private var locationService: LocationService
    
    private var locationPoint: LocationPoint?
    
    init(view: VenueView, foursquareService: FoursquareService, locationService: LocationService) {
        self.venueView = view
        self.foursquareService = foursquareService
        self.locationService = locationService
        
        super.init()
        
        self.locationService.delegate = self
        self.locationService.startReceivingLocation()
    }
    
    func getVenue(basedOn keyword: String) {
        
        if let currentLocation = self.locationPoint {
            self.venueView.startLoading()
            
            self.foursquareService.callVenueSearch(searchFraze: keyword, location: currentLocation) { (result) in
                
                switch result {
                case .success(result: let venues as [VenueModel]):
                    self.venueView.finishLoading()
                    
                    var venueViewDataArray = [VenueViewData]()
                    for venue in venues {
                        let name = venue.name
                        var address = ""
                        var distance = ""
                        if let addressModel = venue.venueAddress {
                            address = addressModel.venueAddressToDisplay
                            distance = addressModel.venueDistanceToDisplay
                        }
                        venueViewDataArray.append(VenueViewData(name: name, address: address, distance: distance))
                    }
                    self.venueView.setVenues(venues: venueViewDataArray)
                case .failure(error: _):
                    self.venueView.finishLoading()
                default:
                    self.venueView.finishLoading()
                }
            }
        }
    }
}

extension VenuePresenter: LocationServiceDelegate {
    func locationUpdated(locationPoint: LocationPoint) {
        self.locationPoint = locationPoint
    }
}
