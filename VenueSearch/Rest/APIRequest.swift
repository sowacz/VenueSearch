//
//  APIRequest.swift
//  VenueSearch
//
//  Created by Grzegorz Sowa on 25/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import Foundation

typealias CompletionClosure = ((APIRequest.CallbackResult)->Void)

class APIRequest {
    
    enum CallbackResult {
        case success(result: Any)
        case failure(error: Error)
    }
    
    enum APIRequestError: Error {
        case errorDeserializingData
        case wrongResponseStatusCode
    }
    
    private let session: URLSession
 
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getJsonResponse(urlRequest: URLRequest, completionHandler: @escaping CompletionClosure) {
        
        let task = self.session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                completionHandler(.failure(error: error))
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    DispatchQueue.main.async {
                        completionHandler(.success(result: jsonResponse))
                    }
                } catch {
                    completionHandler(.failure(error: APIRequestError.errorDeserializingData))
                }
            } else {
                completionHandler(.failure(error: APIRequestError.wrongResponseStatusCode))
            }
        }
        task.resume()
    }
    
}
