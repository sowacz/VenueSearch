//
//  VenueSearchSlowTests.swift
//  VenueSearchSlowTests
//
//  Created by Grzegorz Sowa on 27/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import XCTest
@testable import VenueSearch

class VenueSearchSlowTests: XCTestCase {
    
    var sut: URLSession!
    
    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: .default)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCallToFoursquareCompletes() {
        // given
         let foursquareService = FoursquareService()
        
        let url =
            URL(string: "https://api.foursquare.com/v2/venues/search?client_id=\(foursquareService.clientId)&client_secret=\(foursquareService.clientSecret)&ll=40.7,-74&query=sushi&v=20190526")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
