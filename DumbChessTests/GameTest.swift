//
//  GameTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 9/1/21.
//

import XCTest

@testable import DumbChess

class TestGameDelegate: GameDelegate {
    var whiteWon = false
    var blackWon = false
    var stalemate = false
    var currentBoard = Board()
    func gameEndWithWinner(_ winner: PieceColor) {
        if (winner == .White){
            whiteWon = true
        }
        else{
            blackWon = true
        }
    }
    
    func gameEndWithStaleMate() {
        stalemate = true
    }
    
    func player(_ player: Player, finishedMoveWithBoard: Board) {
        currentBoard = finishedMoveWithBoard
    }
}

class RandomPlayer: Player {
    override func playTurnOnBoard(_ onBoard: Board, completion: @escaping (Board) -> Void) {
        let eval = BoardEvaluation(withBoard: onBoard, startingColor: color)
        eval.computeLegalMovesForColor(color)
        guard let (origin, possibleMoves) = eval.legalMovesForPieces[color]?.first else {
            return
        }
        guard let destination = possibleMoves.first else{
            return
        }
        guard let piece = onBoard.pieces[origin] else {
            return
        }
        completion(piece.moveToPosition(destination, fromPosistion: origin, onBoard: onBoard))
    }
}

class GameTest: XCTestCase {
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testStart() {
        let bot = DumbBotPlayer(withColor: .Black)
        bot.botDepthEachLayer = [1.0,1.0]
        let testGame = Game(withPlayerWhite: RandomPlayer(withColor: .White), andPlayerBlack: bot)
        testGame.currentBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 1, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        testGame.currentPlayer = bot
        
        let delegate = TestGameDelegate()
        
        testGame.gameDelegate = delegate
        
        let expectation = expectation(description: "chooses moves")
        
        testGame.start {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        let testRook = Rook(withColor: .Black)
        testRook.hasMoved = true
        
        XCTAssertTrue(delegate.blackWon)
        
        XCTAssertEqual(delegate.currentBoard.pieces, [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 7, column: 1): testRook,
            Square(row: 7, column: 6): King(withColor: .White)
        ])
    }

}
