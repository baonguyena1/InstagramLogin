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
        }
    }
    
    private let service = FollowedService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowedCell.cellIdentifier() , for: indexPath) as! FollowedCell

        cell.followedViewModel = followedViewModels[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
