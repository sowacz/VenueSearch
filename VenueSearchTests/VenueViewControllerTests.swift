//
//  VenueViewControllerTests.swift
//  VenueSearchTests
//
//  Created by Grzegorz Sowa on 27/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import XCTest
@testable import VenueSearch

class VenueViewControllerTests: XCTestCase {
    
    var sut: VenueViewController!
    var venuePresenter: VenuePresenter!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "VenueViewController") as? VenueViewController
        _ = sut.view
        
        venuePresenter = VenuePresenter(view: sut, foursquareService: FoursquareServiceMock(), locationService: LocationServiceMock())
        sut.initialize(presenter: venuePresenter)
    }

    override func tearDown() {
        sut = nil
        venuePresenter = nil
        super.tearDown()
    }

    func testSearchBarChangeValueTriggerOfFetchVenue() {
        sut.searchBar.delegate?.searchBar?(sut.searchBar, textDidChange: "A")
        
        XCTAssertNotEqual(0, self.sut.getCurrentFetchedVenues().count)
    }

}
