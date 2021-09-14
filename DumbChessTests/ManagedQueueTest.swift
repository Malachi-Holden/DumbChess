//
//  ManagedQueueTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 8/29/21.
//

import XCTest

@testable import DumbChess

class ManagedQueueTest: XCTestCase {
    
    var testQueue = ManagedQueue()
    var sharedResource = 100

    override func setUpWithError() throws {
        testQueue = ManagedQueue()
        sharedResource = 100
    }
    
    func testRunQueueSharedResource() {
        for _ in 1...1000 {
            testQueue.addTask {
                var amountToAdd = 100000
                for _ in 1...99999{
                    amountToAdd -= 1
                }
                DispatchQueue.main.async {
                    self.sharedResource += amountToAdd
                }
            }
        }
        let expectation = expectation(description: "resource check")
        testQueue.setOnAllComplete {
            XCTAssertEqual(self.sharedResource, 1100)
            expectation.fulfill()
        }
        testQueue.run()
        waitForExpectations(timeout: 10, handler: nil)
    }

}
