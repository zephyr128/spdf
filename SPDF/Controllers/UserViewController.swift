//
//  UserViewController.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import UIKit
import MessageUI

class UserViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var userEmail: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoundedImage()
        setImage()
        setData()
    }
    
    private func setData() {
        if let user = user {
            userName.text = "\(user.firstName) \(user.lastName)"
            userAge.text = "Age \(user.age)"
            userEmail.setTitle(user.email, for: .normal)
            
        }
    }
    
    private func setImage() {
        if let user = user {
            UserManager.shared.getUserImage(imageUrl: user.imageLarge) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.userImage.image = image
                    }
                }
            }
        }
    }
    
    private func setRoundedImage() {
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.clipsToBounds = true
    }
    
    @IBAction func onEmailAction(_ sender: UIButton) {
        if let user = user, MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(user.email)"])
            mail.setMessageBody("<p>Hello \(user.firstName)!</p>", isHTML: true)
                present(mail, animated: true)
        } else {
                // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
