//
//  DumbBotPlayerTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 9/9/21.
//

import XCTest

@testable import DumbChess

class DumbBotPlayerTest: XCTestCase {
    
    var testBot = DumbBotPlayer(withColor: .White)

    override func setUpWithError() throws {
        testBot = DumbBotPlayer(withColor: .White)
    }

    func testPlayTurnOnBoard() {
        testBot = DumbBotPlayer(withColor: .Black)
        testBot.botDepthEachLayer = [1.0,1.0]
        let testboard = Board()
        
        testboard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 1, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        
        let expectation = expectation(description: "checkmates")
        
        testBot.playTurnOnBoard(testboard) { board in
            expectation.fulfill()
            XCTAssertTrue(board.isCheckMate(forColor: .White))
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

}
