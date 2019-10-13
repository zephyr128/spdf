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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        title.text = nil
        subtitle.text = nil
        userImage.image = nil
    }

}
