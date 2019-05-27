//
//  VenueSearchService.swift
//  VenueSearch
//
//  Created by Grzegorz Sowa on 25/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import Foundation
import CoreLocation

class FoursquareService {
    
    enum FoursquareParameter: String {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case location = "ll"
        case query = "query"
        case version = "v"
    }
    
    let foursquareHostUrl = "https://api.foursquare.com/v2/"
    let clientId = "CLIENT_ID_VALUE"
    let clientSecret = "CLIENT_SECRET_VALUE"
    let versionValue = "20190526"
    
    enum RequestType: String {
        case venueSearch = "venues/search"
    }
    
    private let apiRequest: APIRequest
    
    init(apiRequest: APIRequest = APIRequest(session: URLSession(configuration: .default))) {
        self.apiRequest = apiRequest
    }
    
    public func callVenueSearch(searchFraze: String, location: LocationPoint, completionHandler: @escaping CompletionClosure) {
        
        let urlString = foursquareHostUrl + RequestType.venueSearch.rawValue
        var components = URLComponents(string: urlString)
        components?.queryItems = [
            URLQueryItem(name: FoursquareParameter.clientId.rawValue, value: clientId),
            URLQueryItem(name: FoursquareParameter.clientSecret.rawValue, value: clientSecret),
            URLQueryItem(name: FoursquareParameter.query.rawValue, value: searchFraze),
            URLQueryItem(name: FoursquareParameter.version.rawValue, value: versionValue),
            URLQueryItem(name: FoursquareParameter.location.rawValue, value: location.foursquareLocationValue)
        ]
        
        if let url = components?.url {
            let urlRequest = URLRequest(url: url)
            
            apiRequest.getJsonResponse(urlRequest: urlRequest) { (result) in
                switch result {
                case .success(result: let resultData):
                    var fetchedVenues = [VenueModel]()
                    if  let resultDict = resultData as? [String: Any],
                        let responseDict = resultDict["response"] as? [String: Any],
                        let venues = responseDict["venues"] as? [[String: Any]] {
                        for venueDict in venues {
                            fetchedVenues.append(VenueModel(dictionary: venueDict))
                        }
                        
                        completionHandler(.success(result: fetchedVenues))
                    }
                case .failure(error: let error):
                    completionHandler(.failure(error: error))
                }
            }
        }
    }
    
}
