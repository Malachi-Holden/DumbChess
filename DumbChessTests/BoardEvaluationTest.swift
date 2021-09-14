//
//  BoardEvaluationTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 8/26/21.
//

import XCTest

@testable import DumbChess

class BoardEvaluationTest: XCTestCase {
    
    var testBoard = Board()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testBoard = Board()
    }

    func testComputeLegalMovesForColorFindPin() {
        
        // k7/1q6/8/8/8/8/5K2/2BB4 w - - 0 1
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        let testBoardEval = BoardEvaluation(withBoard: testBoard, startingColor: .White)
        testBoardEval.computeLegalMovesForColor(.White)
//        testBoardEval.computeLegalMovesForColor(.White)
        XCTAssertEqual(testBoardEval.totalLegalMovesForColors[.White], 20)
        XCTAssertEqual(testBoardEval.legalMovesForPieces[.White]?.count, 3)
        XCTAssertEqual(testBoardEval.legalMovesForPieces[.Black]?.count, 2)
        //Black
        XCTAssertEqual(testBoardEval.legalMovesForPieces[.Black]?[Square(row: 0, column: 0)], [])
        XCTAssertEqual(testBoardEval.legalMovesForPieces[.Black]?[Square(row: 1, column: 1)], [])
        //first bishop
        XCTAssertEqual(testBoardEval.legalMovesForPieces[.White]?[Square(row: 7, column: 2)]?.count, 7)
        XCTAssertEqual(Set(testBoardEval.legalMovesForPieces[.White]?[Square(row: 7, column: 2)] ?? []), Set([Square(row: 5, column: 0),Square(row: 6, column: 1),Square(row: 6, column: 3),Square(row: 5, column: 4),Square(row: 4, column: 5),Square(row: 3, column: 6),Square(row: 2, column: 7)]))
        //second bishop
        XCTAssertEqual(testBoardEval.legalMovesForPieces[.White]?[Square(row: 7, column: 3)]?.count, 7)
        XCTAssertEqual(Set(testBoardEval.legalMovesForPieces[.White]?[Square(row: 7, column: 3)] ?? []), Set([Square(row: 4, column: 0),Square(row: 5, column: 1),Square(row: 6, column: 2),Square(row: 6, column: 4),Square(row: 5, column: 5),Square(row: 4, column: 6),Square(row: 3, column: 7)]))
        //king
        XCTAssertEqual(testBoardEval.legalMovesForPieces[.White]?[Square(row: 6, column: 5)]?.count, 6)
        XCTAssertEqual(Set(testBoardEval.legalMovesForPieces[.White]?[Square(row: 6, column: 5)] ?? []), Set([Square(row: 5, column: 4),Square(row: 5, column: 6),Square(row: 6, column: 4),Square(row: 7, column: 4),Square(row: 7, column: 5),Square(row: 7, column: 6)]))
    }
    
    func testComputeLegalMovesFindPin2() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 2, column: 2): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        
        let testBoardEval = BoardEvaluation(withBoard: testBoard, startingColor: .White)
        testBoardEval.computeLegalMovesForColor(.White)
        XCTAssertTrue(testBoardEval.legalMovesForPieces[.White]![Square(row:5, column: 5)]!.contains(Square(row: 2, column: 2)))
    }
    
    func testComputeLegalMovesForColorEarlyCheckmate() {
        // fen k7/1r6/8/8/8/8/5PPP/6K1 w - - 0 1
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 1, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        let testBoardEval = BoardEvaluation(withBoard: testBoard, startingColor: .White)
        testBoardEval.computeLegalMovesForColor(.White)
    }
    
    func testComputeLegalMovesForColorPerformance() {
        // k7/1q6/8/8/8/8/5K2/2BB4 w - - 0 1
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        self.measure {
            for _ in 0...1000{
                let testEval = BoardEvaluation(withBoard: testBoard, startingColor: .White)
                testEval.computeLegalMovesForColor(.White)
            }
        }
    }

}
