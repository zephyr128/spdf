//
//  UsersNetworkManager.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//
import Foundation
import UIKit

struct UserManager {
    
    private let baseUrl = "https://randomuser.me/api"
    
    private let pageStr = "page"
    
    private let countStr = "results"
    
    private let restManager = RestManager()
    
    private static let cachedImages = NSCache<NSString, UIImage>()
    
    public static let shared = UserManager()
    
    
    func fetchUsers(page: Int, count: Int, completion: @escaping (_ data: [User]?) -> Void) {
        
        guard page > 0,
            count > 0,
            let url = URL(string: "\(baseUrl)?\(pageStr)=\(page)&\(countStr)=\(count)")
            else {
                completion(nil)
                return
        }
        
        restManager.get(fromUrl: url) { (data) in
            guard let data = data else { completion(nil); return }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UsersDto.self, from: data)
                completion(self.toUsers(usersDto: response))
            } catch let parsingError {
                print("Error", parsingError)
                completion(nil)
            }
        }
    }
    
    func getUserImage(imageUrl: String, completion: @escaping (_ data: UIImage?) -> Void) {
        // check in cache
        if let cachedImage = UserManager.cachedImages.object(forKey: imageUrl as NSString) {
            completion(cachedImage)
            return
        }
        // else download
        if let url = URL(string: imageUrl) {
            restManager.get(fromUrl: url) { (data) in
                guard let data = data else { completion(nil); return }
                guard let image = UIImage(data: data) else { completion(nil); return }
                // cache
                UserManager.cachedImages.setObject(image, forKey: imageUrl as NSString)
                completion(image)
                return
            }
        }
    }
    
    private func toUsers(usersDto: UsersDto) -> [User] {
        var users: [User] = []
        for userDto in usersDto.result {
            let user = User(firstName: userDto.name.first,
                            lastName: userDto.name.last,
                            age: userDto.dateOfBirth.age,
                            imageLarge: userDto.image.large,
                            imageMedium: userDto.image.medium,
                            imageThumb: userDto.image.thumbnail,
                            nationality: userDto.nationality,
                            email: userDto.email)
            users.append(user)
        }
        return users
    }
    
}
