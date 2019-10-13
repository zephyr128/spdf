//
//  User.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import Foundation
import UIKit

struct User {
    public let firstName: String
    public let lastName: String
    public let age: Int
    public let imageLarge: String
    public let imageMedium: String
    public let imageThumb: String
    public let nationality: String
    public var flag: String {
        get {
            return self.flag(country: nationality)
        }
    }
    public let email: String
    
    private func flag(country:String) -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        var error = false
        for i in country.utf16 {
            if let unicode = UnicodeScalar(base + Int(i)) {
                usv.append(unicode)
            }
            else {
                error = true
                continue
            }
        }
        
        return error ? nationality : String(usv)
    }
}
