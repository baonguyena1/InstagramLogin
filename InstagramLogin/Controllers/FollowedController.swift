//
//  FollowedController.swift
//  InstagramLogin
//
//  Created by Bao Nguyen on 4/12/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import SVProgressHUD

class FollowedController: UITableViewController {
    
    private var followedViewModels = [UserViewModel]() {
        didSet {
            self.tableView.reloadData()
            unfollowButton.isEnabled = followedViewModels.count > 0
        }
    }
    
    @IBOutlet weak var unfollowButton: UIBarButtonItem!
    
    private let service = FollowedService()
    private let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        unfollowButton.isEnabled = false
        initRefreshControl()
        getFollowedList(from: service)
    }
    
    private func initRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(fullRefresh), for: .valueChanged)
    }
    
    @objc private func fullRefresh() {
        self.refreshControl?.beginRefreshing()
        getFollowedList(from: service)
    }
    
    // MARK: call followed service to get followed list
    private func getFollowedList<S: Getable>(from service: S) where S.T == Array<User?> {
        SVProgressHUD.show()
        service.get { [weak self] (result) in
            switch result {
            case .error(let error):
                print(error)
            case .success(let followeds):
                let followedArray = followeds.flatMap { UserViewModel(user: $0!) }
                self?.followedViewModels = followedArray
            }
            SVProgressHUD.dismiss()
            self?.refreshControl?.endRefreshing()
        }
    }
    
    private func unfollowUser<S: Postable>(from service: S, for userId: String) where S.P == [String: Any] {
        dispatchGroup.enter()
        service.unfollow(with: userId, parameters: ["action": "unfollow"]) { (result) in
            switch result {
            case .error(let error):
                print(error)
            case .success(let json):
                print(json)
            }
            self.dispatchGroup.leave()
        }
    }

    @IBAction func unfollow(_ sender: UIBarButtonItem) {
        if followedViewModels.count <= 0 {
            return
        }
        SVProgressHUD.show()
        for followedViewModel in followedViewModels {
            unfollowUser(from: service, for: followedViewModel.id)
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { 
            SVProgressHUD.dismiss()
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowedCell.cellIdentifier() , for: indexPath) as! FollowedCell

        cell.followedViewModel = followedViewModels[indexPath.row]

        return cell
    }
    
    

}
