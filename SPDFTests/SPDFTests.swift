//
//  SPDFTests.swift
//  SPDFTests
//
//  Created by Nenad Prahovljanovic on 10/13/19.
//  Copyright © 2019 Nenad Prahovljanovic. All rights reserved.
//

import XCTest
@testable import SPDF

class SPDFTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUserFetch() {
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Fetch user data")
        
        UserManager.shared.fetchUsers(page: 1, count: 10, completion: { (users) in
            
            // Make sure we downloaded some data.
            XCTAssertNotNil(users, "No data was downloaded.")
            
            XCTAssertEqual(users?.count, 10, "User count mismatch")
            
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
            
        })
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }

}
