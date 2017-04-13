//
//  UserViewModel.swift
//  InstagramLogin
//
//  Created by Bao Nguyen on 4/13/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation

struct UserViewModel {
    var username: String
    var profile_picture_url: String
    var full_name: String
    var id: String
    
    init(user: User) {
        username = user.username
        profile_picture_url = user.profile_picture
        full_name = user.full_name.capitalized
        id = user.id
    }
}
