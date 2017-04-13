//
//  JSONDownloader.swift
//  InstagramLogin
//
//  Created by Bao Nguyen on 4/12/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
}

enum Result<T> {
    case success(T)
    case error(APIError)
}

struct JSONDownloader {
    
    private let session: URLSession
    
    init() {
        self.init(configuration: .default)
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    typealias JSON = [String: Any]
    typealias JSONTaskCompletionHandler = (Result<JSON>) -> ()
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.error(.requestFailed))
                return
            }
            
            if httpResponse.statusCode != 200 {
                completion(.error(.responseUnsuccessful))
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! JSON
                    DispatchQueue.main.async {
                        completion(.success(json))
                    }
                } catch {
                    completion(.error(.jsonConversionFailure))
                }
            } else {
                completion(.error(.invalidData))
            }
        }
        
        return task
    }
}
