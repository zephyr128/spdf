//
//  ViewController.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkIndicatorView: NetworkIndicationView!
    
    @IBOutlet weak var networkIndicatorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var networkIndicatorViewLabel: UILabel!
    
    private let countPerPage = 20
    
    private var currentPage = 0
    
    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addObservers()
        setRefreshControl()
        getUsers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkAvailable), name: .networkAvailable , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noNetwork), name: .noNetwork , object: nil)
    }
    
    @objc func networkAvailable() {
        updateNetworkNotification(isOnline: true)
        UIView.animate(withDuration: 0.5, delay: 4, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in }
    }
    
    @objc func noNetwork() {
        updateNetworkNotification(isOnline: false)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateNetworkNotification(isOnline: Bool) {
        networkIndicatorViewHeight.constant = isOnline ? 0 : 25
        networkIndicatorViewLabel.text = isOnline ? networkIndicatorView.networkAvailableMessage : networkIndicatorView.noNetworkMessage
        networkIndicatorView.isNetworkAvailable = isOnline
    }
    
    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func refresh(refreshControl: UIRefreshControl) {
        getUsers()
        refreshControl.endRefreshing()
    }
    
    private func resetData() {
        currentPage = 0
        users.removeAll()
    }
    
    private func getUsers() {
        currentPage += 1
        UserManager.shared.fetchUsers(page: currentPage, count: countPerPage) { (users) in
            if let users = users {
                if self.currentPage == 1 { self.resetData() } // If the refresh was triggered
                self.users.append(contentsOf: users)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UserTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        
        if indexPath.row <= users.count {
            
            cell.title.text = "\(users[indexPath.row].firstName) \(users[indexPath.row].lastName) \(users[indexPath.row].flag)"
            
            cell.subtitle.text = "Age \(users[indexPath.row].age)"
            
            UserManager.shared.getUserImage(imageUrl: users[indexPath.row].imageThumb, completion: { (image) in
                DispatchQueue.main.async {
                    cell.userImage.image = image
                }
            })
            
            if indexPath.row == users.count - 1 { // last cell
               getUsers()
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Users count \(users.count)")
        return users.count
    }
    
}


