//
//  ViewController.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUsers()
    }
    
    private func getUsers() {
        UserManager.shared.fetchUsers(page: 1, count: 5) { (users) in
            self.users = users ?? []
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
        
        cell.title.text = "\(users[indexPath.row].firstName) \(users[indexPath.row].lastName)"
        
        cell.subtitle.text = "Age \(users[indexPath.row].age)"
        
        UserManager.shared.getUserImage(imageUrl: users[indexPath.row].imageThumb, completion: { (image) in
            DispatchQueue.main.async {
                cell.userImage.image = image
            }
        })
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Users count \(users.count)")
        return users.count
    }
    
}


