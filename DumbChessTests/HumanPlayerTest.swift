//
//  HumanPlayerTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 9/10/21.
//

import XCTest

@testable import DumbChess

class DumbHumanUI: HumanInteractor{
    var humanHasChosen = false
    var currentBoard = Board.startingBoard()
    func startHumanTurn(_ onBoard: Board) {
        humanHasChosen = false
        currentBoard = onBoard
        if let piece = currentBoard.pieces[Square(row: 0, column: 0)] {
            currentBoard = piece.moveToPosition(Square(row: 1, column: 1), fromPosistion: Square(row: 0, column: 0), onBoard: currentBoard)
            humanHasChosen = true
            return
        }
    }
    
    func hasHumanChosen() -> Bool {
        return humanHasChosen
    }
    
    func getBoard() -> Board {
        return currentBoard
    }
}

class HumanPlayerTest: XCTestCase {
    var testHumanPlayer = HumanPlayer(withColor: .White)
    var testUI = DumbHumanUI()
    override func setUpWithError() throws {
        testHumanPlayer = HumanPlayer(withColor: .White)
        testUI = DumbHumanUI()
        testHumanPlayer.humanInteractor = testUI
    }
    
    func testPlayTurnOnBoard() {
        let testBoard = Board()
        testBoard.pieces = [
            Square(row: 0, column: 0): Piece(withColor: .White)
        ]
        let expectation = expectation(description: "plays 1,1")
        testHumanPlayer.playTurnOnBoard(testBoard) { resultBoard in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        let expectedPiece = Piece(withColor: .White)
        expectedPiece.hasMoved = true
        XCTAssertEqual(testUI.currentBoard.pieces, [
            Square(row: 1, column: 1): expectedPiece
        ])
    }

}
