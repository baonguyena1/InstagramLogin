//
//  FollowedService.swift
//  InstagramLogin
//
//  Created by Bao Nguyen on 4/12/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

protocol Getable {
    associatedtype T
    func get(completion: @escaping (Result<T>) -> ())
}

struct FollowedService: Getable {
    
    private let endpoint: String = "https://api.instagram.com/v1/users/self/followed-by?access_token="
    private let downloader = JSONDownloader()
    
    //the associated type is inferred by <[User??]>
    typealias FollowedCompletionHandler = (Result<[User?]>) -> ()
    
    func get(completion: @escaping FollowedCompletionHandler) {
        guard let access_token = UserDefaults.standard.value(forKey: ACCESS_TOKEN) as? String,
            let url = URL(string: self.endpoint.appending(access_token)) else {
            completion(.error(.invalidURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let task = downloader.jsonTask(with: urlRequest) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    completion(.error(error))
                case .success(let json):
                    guard let followedArray = json["data"] as? [[String: Any]] else {
                            completion(.error(.jsonParsingFailure))
                            return
                    }
                    let followeds = followedArray.map { User(json: $0) }
                    completion(.success(followeds))
                }
            }
        }
        task.resume()
    }
}
