//
//  User.swift
//  InstagramLogin
//
//  Created by Bao Nguyen on 4/12/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation

struct User {
    var username: String
    var profile_picture: String
    var full_name: String
    var id: String
    
    init?(json: [String: Any]) {
        guard let username = json[USERNAME] as? String,
            let profile_picture = json[PROFILE_PICTURE] as? String,
            let  full_name = json[FULL_NAME] as? String,
            let id = json[ID] as? String else {
                return nil
        }
        self.username = username
        self.profile_picture = profile_picture
        self.full_name = full_name
        self.id = id
    }
}
