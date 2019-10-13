//
//  Users.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import Foundation

struct Users: Decodable {
    
    public let result: [User]
    
    enum CodingKeys: String, CodingKey {
        case result = "results"
    }
    
    struct User: Decodable {
        
        public let email: String
        public let name: Name
        public let dateOfBirth: DateOfBirth
        public let nationality: String
        public let image: Image
        
        private enum CodingKeys: String, CodingKey {
            case email = "email"
            case name = "name"
            case dateOfBirth = "dob"
            case nationality = "nat"
            case image = "picture"
        }
        
        struct Name: Decodable {
            public let title: String
            public let first: String
            public let last: String
            private enum CodingKeys: String, CodingKey {
                case title = "title"
                case first = "first"
                case last = "last"
            }
        }
        
        struct DateOfBirth: Decodable {
            public let date: String
            public let age: Int
            private enum CodingKeys: String, CodingKey {
                case date = "date"
                case age = "age"
            }
        }
        
        struct Image: Decodable {
            public let large: String
            public let medium: String
            public let thumbnail:String
            private enum CodingKeys: String, CodingKey {
                case large = "large"
                case medium = "medium"
                case thumbnail = "thumbnail"
            }
       }
        
    }
}
