//
//  APIRequestTests.swift
//  VenueSearchTests
//
//  Created by Grzegorz Sowa on 27/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import XCTest
@testable import VenueSearch

class APIRequestTests: XCTestCase {

    class URLSessionDataTaskMock: URLSessionDataTask {
        private let closure: () -> Void
        init(closure: @escaping () -> Void) {
            self.closure = closure
        }
        override func resume() {
            closure()
        }
    }
    
    class URLSessionMock: URLSession {
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var data: Data?
        var response: HTTPURLResponse?
        var error: Error?
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            let data = self.data
            let error = self.error
            let response = self.response
            return URLSessionDataTaskMock {
                completionHandler(data, response, error)
            }
        }
    }
    
    var sut: APIRequest!
    var session: URLSessionMock!
    var foursquareService: FoursquareService!
    
    override func setUp() {
        session = URLSessionMock()
        sut = APIRequest(session: session)
        foursquareService = FoursquareService(apiRequest: sut)
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "allianz", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        session.data = data
        
        let url = URL(fileURLWithPath: "url")
        
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        session.response = urlResponse
        
    }

    override func tearDown() {
        sut = nil
        session = nil
        foursquareService = nil
        super.tearDown()
    }

    func testSuccessfulAPIRequestResponse() {
        let url = URL(fileURLWithPath: "url")
        let urlRequest = URLRequest(url: url)
        
        sut.getJsonResponse(urlRequest: urlRequest) { (result) in
            if case .success(_) = result {
                //Success
            } else {
                XCTFail("Wrong response")
            }
        }
    }
    
    func testSuccessfulFoursquareServiceResponseParsing() {
        
        foursquareService.callVenueSearch(searchFraze: "fake", location: LocationPoint(latitude: "1", longitude: "1")) { (result) in
            if case .success(_) = result {
                //Success
            } else {
                XCTFail("Wrong response")
            }
        }
    }
    
    func testFoursquareServiceResponseParsingCorrectness() {
        
        foursquareService.callVenueSearch(searchFraze: "fake", location: LocationPoint(latitude: "1", longitude: "1")) { (result) in
            switch result {
            case .success(result: let responseData):
                if let venues = responseData as? [VenueModel] {
                    
                    let testVenue = VenueModel(name: "Allian")
                    testVenue.venueAddress = VenueLocationModel(address: [ "Świętojańska 72", "Gdynia", "Polska" ], distance: 12045)
                    
                    XCTAssertEqual(venues[0], testVenue, "Wrong result venue model")
                } else {
                    XCTFail("Wrong response type")
                }
            case .failure(error: _):
                XCTFail("Wrong response")
            }
        }
    }

}
