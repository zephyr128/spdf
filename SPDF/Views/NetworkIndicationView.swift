//
//  NetworkIndicationView.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import UIKit
@IBDesignable
class NetworkIndicationView: UIView {
    @IBInspectable var networkAvailableColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var noNetworkColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var isNetworkAvailable: Bool = true {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var networkAvailableMessage: String = "Back online"
    
    @IBInspectable var noNetworkMessage: String = "No network"
    
    func updateView() {
      self.backgroundColor = isNetworkAvailable ? networkAvailableColor : noNetworkColor
    }

}
