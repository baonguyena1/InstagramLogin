//
//  Cacheable.swift
//  MVVMJSONTutorial
//
//  Created by Bao Nguyen on 4/9/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

protocol Cachable {}

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView: Cachable {}

extension Cachable where Self: UIImageView {
    
    typealias SuccessCompletion = (Bool) -> ()
    
    func loadImageWith(_ urlString: String, placeHolder: UIImage?, completion: @escaping SuccessCompletion) {
        
        self.image = nil
        if let image = imageCache.object(forKey: NSString(string: urlString)) {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completion(true)
            }
            return
        }
        
        self.image = placeHolder
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        if let downloadImage = UIImage(data: data) {
                            imageCache.setObject(downloadImage, forKey: NSString(string: urlString))
                            DispatchQueue.main.async { [weak self] in
                                self?.image = downloadImage
                                completion(true)
                            }
                        }
                    }
                }
            }).resume()
        }
        
    }
}
