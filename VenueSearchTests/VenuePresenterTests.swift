//
//  VenueSearchTests.swift
//  VenueSearchTests
//
//  Created by Grzegorz Sowa on 24/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import XCTest
@testable import VenueSearch

class FoursquareServiceMock: FoursquareService {
    override public func callVenueSearch(searchFraze: String, location: LocationPoint, completionHandler: @escaping CompletionClosure) {
        
        let firstVenue = VenueModel(name: "First")
        let firstVenueLocation = VenueLocationModel(address: ["Kossaka 10"], distance: 10)
        firstVenue.venueAddress = firstVenueLocation
        
        completionHandler(.success(result: [firstVenue]))
    }
}

class LocationServiceMock: LocationService {
    override func startReceivingLocation() {
        self.delegate?.locationUpdated(locationPoint: LocationPoint(latitude: "1", longitude: "1"))
    }
}

class VenuePresenterTests: XCTestCase {
    
    class VenueViewMock: NSObject, VenueView {
        
        static var venues: [VenueViewData]?
        
        func startLoading() {
            
        }
        
        func finishLoading() {
            
        }
        
        func setVenues(venues: [VenueViewData]) {
            VenueViewMock.venues = venues
        }
    }
    
    var sut: VenuePresenter!
    var venueView: VenueViewMock!
    
    override func setUp() {
        super.setUp()
        venueView = VenueViewMock()
        sut = VenuePresenter(view: venueView, foursquareService: FoursquareServiceMock(), locationService: LocationServiceMock())
    }

    override func tearDown() {
        sut = nil
        venueView = nil
        super.tearDown()
    }

    func testVenuePresenterGetVenue() {
       sut.getVenue(basedOn: "fake")
        if let resultVenues = VenueViewMock.venues {
            XCTAssertEqual(1, resultVenues.count, "Wrong result of getVenue method")
        } else {
            XCTFail("No result venue array found.")
        }
    }
    
    func testVenuePresenterVenueViewDataCorrectness() {
        sut.getVenue(basedOn: "fake")
        if let resultVenues = VenueViewMock.venues {
            let testVenue = VenueViewData(name: "First", address: "Kossaka 10", distance: "Dist. 10 m")
            XCTAssertEqual(resultVenues[0], testVenue)
        } else {
            XCTFail("No result venue array found.")
        }
    }

}
