//
//  UserTableViewCell.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setRoundedImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        title.text = nil
        subtitle.text = nil
        userImage.image = nil
    }
    
    private func setRoundedImage() {
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.clipsToBounds = true
    }

}
