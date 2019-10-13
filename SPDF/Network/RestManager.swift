//
//  NetworkService.swift
//  SPDF
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//
import Foundation

/// A simple REST manager that uses URLSession
struct RestManager {
    
    /// The timeout interval to use when waiting for additional data
    private static let timeoutIntervalRequest: TimeInterval = 15
    /// The maximum amount of time that a resource request should be allowed to take.
    private static let timeoutIntervalResource: TimeInterval = 30
    // Define the session config
    private var sessionConfig: URLSessionConfiguration {
        get {
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = RestManager.timeoutIntervalRequest
            sessionConfig.timeoutIntervalForResource = RestManager.timeoutIntervalResource
            return sessionConfig
        }
    }
    
    private var session: URLSession?
    
    /// Will initialize with default session configuration
    init() {
        session = URLSession(configuration: sessionConfig)
    }
    
    init(session: URLSession) {
        self.session = session
    }
    
    
    /// GET request
    /// - Parameter url: url
    /// - Parameter completion: Data on success, nil otherwise
    func get(fromUrl url:URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let task = self.session?.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { completion(nil); return }
                completion(data)
            })
            task?.resume()
        }
    }
    
    // TODO: Extend the RestManager with the rest of HTTP methods
}
