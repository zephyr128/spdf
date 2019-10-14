//
//  ViewController.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkIndicatorView: NetworkIndicationView!
    
    @IBOutlet weak var networkIndicatorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var networkIndicatorViewLabel: UILabel!
    
    private let countPerPage = 20
    
    private var currentPage = 0
    
    private var users: [User] = []
    
    private var isRefreshing = false
    
    private var isNetworkAvailable = true
    
    let userSegueIdentifier = "UserSegueIdentifier"
    
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
        isNetworkAvailable = isOnline
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
        isRefreshing = true
        getUsers()
        refreshControl.endRefreshing()
    }
    
    private func resetData() {
        currentPage = 0
        users.removeAll()
    }
    
    private func getUsers() {
        if isNetworkAvailable {
            currentPage += 1
            UserManager.shared.fetchUsers(page: currentPage, count: countPerPage) { (users) in
                if let users = users {
                    if self.isRefreshing { self.resetData(); self.isRefreshing = false } // If the refresh was triggered
                    self.users.append(contentsOf: users)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == userSegueIdentifier,
            let destination = segue.destination as? UserViewController,
            let row = tableView.indexPathForSelectedRow?.row {
                destination.user = users[row]
            }
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UserTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        
        if indexPath.row <= users.count {
            
            cell.title.text = "\(users[indexPath.row].firstName) \(users[indexPath.row].lastName) \(users[indexPath.row].flag)"
            
            cell.subtitle.text = "Age \(users[indexPath.row].age)"
            
            UserManager.shared.getUserImage(imageUrl: users[indexPath.row].imageThumb, completion: { (image) in
                DispatchQueue.main.async {
                    if let image = image {
                        cell.userImage.image = image
                    }
                }
            })
            
            if indexPath.row == users.count - 1 { // last cell
               getUsers()
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count > 0
        {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.lightText
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: userSegueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


