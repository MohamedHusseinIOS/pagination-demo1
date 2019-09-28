//
//  DataTest.swift
//  pagination-demoTests
//
//  Created by Mohamed Hussien on 28/09/2019.
//  Copyright © 2019 HNF. All rights reserved.
//

import XCTest
@testable import pagination_demo
class DataTest: XCTestCase {

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
    
    func testStorage() {
        // Given
        let givenRepos = Repositories(repositories: [Repository(fullName: "test",
                                                                description: "testtest",
                                                                url: "www.google.com",
                                                                htmlUrl: "www.google.com",
                                                                watchers: 10,
                                                                forks: 2)])

        // When
        do {
            try StorageManager.shared.saveData(value: givenRepos, for: .Repos)
        } catch let error {
            let error = XCTestError(_nsError: error as NSError)
            XCTFail(error.localizedDescription)
        }

        // Then
        do {
            let repos = try StorageManager.shared.fetchData(for: .Repos) as Repositories
            XCTAssertEqual(repos.repositories?.first?.fullName, givenRepos.repositories?.first?.fullName)
        } catch let error {
            let error = XCTestError(_nsError: error as NSError)
            XCTFail(error.localizedDescription)
        }
    }

    func testDataManager(){
        // Given
        let promise = expectation(description: "")
        // When
        DataManager.shared.getRepositories(page: 1, limit: 15, forUser: "JakeWharton") { (response) in
            // Then
            switch response {
            case .success(let value):
                if let repos = value as? [Repository], repos.count == 15 {
                    promise.fulfill()
                } else if let _ = value as? Repositories {
                    XCTFail("offline data")
                } else {
                    XCTFail("Somthing wronge with response value")
                }
            case .failure(let apiError, let data):
                if let message = apiError?.message {
                    XCTFail(message)
                } else if let errorModel = data as? ErrorModel {
                    XCTFail(errorModel.message ?? "")
                }
            }
        }
        wait(for: [promise], timeout: 5)
    }
}
