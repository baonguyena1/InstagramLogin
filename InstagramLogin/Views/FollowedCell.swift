//
//  FollowedCell.swift
//  InstagramLogin
//
//  Created by Bao Nguyen on 4/12/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

class FollowedCell: UITableViewCell {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var fullnameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        fullnameLabel.text = ""
        usernameLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var followedViewModel: UserViewModel! {
        didSet {
            fullnameLabel.text = followedViewModel.full_name
            usernameLabel.text = followedViewModel.username
            avatarImageView.loadImageWith(followedViewModel.profile_picture_url, placeHolder: nil) { (success) in
                
            }
        }
    }

}

extension FollowedCell: Cellable {
    static func cellIdentifier() -> String {
        return "followedCell"
    }
}
