//
//  BoardTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 7/28/21.
//

import XCTest

@testable import DumbChess

class BoardTest: XCTestCase {
    
    var testBoard = Board()

    override func setUpWithError() throws {
        testBoard = Board()
    }
    
    func testStringValue() {
        var testSquare = Square(row: 2, column: 6)
        XCTAssertEqual(testSquare.stringValue(), "G6")
        
        testSquare = Square(row: 0, column: 0)
        XCTAssertEqual(testSquare.stringValue(), "A8")
        
        testSquare = Square(row: 7, column: 1)
        XCTAssertEqual(testSquare.stringValue(), "B1")
    }
    
    func testIsKingInCheck1() {
        
        /*
         fen 8/1k3n1Q/8/3P4/8/1r3B2/8/8 w - - 0 1
         */
        testBoard.pieces = [
            Square(row: 1, column: 1): King(withColor: .Black),
            Square(row: 1, column: 5): Knight(withColor: .Black),
            Square(row: 1, column: 7): Queen(withColor: .White),
            Square(row: 2, column: 4): Knight(withColor: .White),
            Square(row: 3, column: 3): Pawn(withColor: .White),
            Square(row: 5, column: 1): Rook(withColor: .Black),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            
        ]
        
        XCTAssertFalse(testBoard.isKingInCheck(kingColor: .Black))
    }
    
    func testIsKingInCheck2() {
        
        /*
         fen 8/1k3n1Q/8/8/8/1r3B2/8/8 w - - 0 1
         */
        testBoard.pieces = [
            Square(row: 1, column: 1): King(withColor: .Black),
            Square(row: 1, column: 5): Knight(withColor: .Black),
            Square(row: 1, column: 7): Queen(withColor: .White),
            Square(row: 2, column: 4): Knight(withColor: .White),
            Square(row: 5, column: 1): Rook(withColor: .Black),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            
        ]
        
        XCTAssertTrue(testBoard.isKingInCheck(kingColor: .Black))
    }
    
    func testIsKingInCheck3() {
        /*
         fen 1pP5/1Kp5/p1P5/8/8/8/8/8 w - - 0 1
         */
        testBoard.pieces = [
            Square(row: 0, column: 1): Pawn(withColor: .Black),
            Square(row: 0, column: 2): Pawn(withColor: .White),
            Square(row: 1, column: 1): King(withColor: .White),
            Square(row: 1, column: 2): Pawn(withColor: .Black),
            Square(row: 2, column: 0): Pawn(withColor: .Black),
            Square(row: 2, column: 2): Pawn(withColor: .White)
            
        ]
        
        XCTAssertFalse(testBoard.isKingInCheck(kingColor: .White))
    }
    
    func testIsKingInCheck4() {
        /*
         ppP5/1Kp5/p1P5/8/8/8/8/8 w - - 0 1
         */
        testBoard.pieces = [
            Square(row: 0, column: 0): Pawn(withColor: .Black),
            Square(row: 0, column: 1): Pawn(withColor: .Black),
            Square(row: 0, column: 2): Pawn(withColor: .White),
            Square(row: 1, column: 1): King(withColor: .White),
            Square(row: 1, column: 2): Pawn(withColor: .Black),
            Square(row: 2, column: 0): Pawn(withColor: .Black),
            Square(row: 2, column: 2): Pawn(withColor: .White)
            
        ]
        
        XCTAssertTrue(testBoard.isKingInCheck(kingColor: .White))
    }
    
    
    func testIsKingInCheck5() {
        //1k6/1p6/8/8/8/5n2/3Q4/6K1 b - - 0 1
        testBoard.pieces = [
            Square(row: 0, column: 1): King(withColor: .Black),
            Square(row: 1, column: 1): Pawn(withColor: .Black),
            Square(row: 5, column: 5): Knight(withColor: .Black),
            Square(row: 6, column: 3): Queen(withColor: .White),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        XCTAssertTrue(testBoard.isKingInCheck(kingColor: .White))
    }
    
    func testIsStaleMateForTurn() {
        testBoard.pieces = [
            Square(row: 1, column: 7): Bishop(withColor: .Black),
            Square(row: 2, column: 2): King(withColor: .Black),
            Square(row: 2, column: 4): Pawn(withColor: .Black),
            Square(row: 3, column: 4): Pawn(withColor: .White),
            Square(row: 6, column: 6): Rook(withColor: .Black),
            Square(row: 7, column: 0): King(withColor: .White)
        ]
        
        XCTAssertTrue(testBoard.isStaleMateForTurn(.White))
    }
    
    func testIsCheckmateBackRank() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 7, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        XCTAssertTrue(testBoard.isCheckMate(forColor: .White))
    }
    
    func testIsCheckmateOpening() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 3, column: 0): Queen(withColor: .Black),
            Square(row: 5, column: 3): Pawn(withColor: .White),
            Square(row: 6, column: 2): Pawn(withColor: .White),
            Square(row: 6, column: 4): Pawn(withColor: .White),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Queen(withColor: .White),
            Square(row: 7, column: 4): King(withColor: .White),
            Square(row: 7, column: 5): Bishop(withColor: .White)
        ]
        XCTAssertFalse(testBoard.isCheckMate(forColor: .White))
    }
    
    func testIsCheckmateBishop() {
        testBoard.pieces = [
            Square(row: 0, column: 0): Rook(withColor: .Black),
            Square(row: 0, column: 1): Knight(withColor: .Black),
            Square(row: 0, column: 2): Bishop(withColor: .Black),
            Square(row: 0, column: 3): Queen(withColor: .Black),
            Square(row: 0, column: 5): Bishop(withColor: .Black),
            Square(row: 0, column: 7): Rook(withColor: .Black),
            Square(row: 1, column: 1): Pawn(withColor: .Black),
            Square(row: 1, column: 2): Pawn(withColor: .Black),
            Square(row: 1, column: 3): Pawn(withColor: .Black),
            Square(row: 2, column: 0): Pawn(withColor: .Black),
            Square(row: 2, column: 4): Pawn(withColor: .Black),
            Square(row: 2, column: 6): Pawn(withColor: .Black),
            Square(row: 3, column: 0): King(withColor: .Black),
            
            Square(row: 3, column: 3): Pawn(withColor: .White),
            Square(row: 4, column: 0): Knight(withColor: .White),
            Square(row: 4, column: 3): Queen(withColor: .White),
            Square(row: 6, column: 0): Pawn(withColor: .White),
            Square(row: 6, column: 1): Pawn(withColor: .White),
            Square(row: 6, column: 2): Pawn(withColor: .White),
            Square(row: 6, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 7, column: 0): Rook(withColor: .White),
            Square(row: 7, column: 4): King(withColor: .White),
            Square(row: 7, column: 5): Bishop(withColor: .White),
            Square(row: 7, column: 7): Rook(withColor: .White)
        ]
        
        XCTAssertFalse(testBoard.isCheckMate(forColor: .Black))
    }
    
    func testGameOutcomeForTurn() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        XCTAssertEqual(testBoard.gameOutcomeForTurn(.White), .InPlay)
    }
    
    func testGameOutcomeForTurnHuge() {
        testBoard.pieces = [
            Square(row: 0, column: 0): Rook(withColor: .Black),
            Square(row: 0, column: 1): Knight(withColor: .Black),
            Square(row: 0, column: 2): Bishop(withColor: .Black),
            Square(row: 0, column: 3): Queen(withColor: .Black),
            Square(row: 0, column: 5): Bishop(withColor: .Black),
            Square(row: 0, column: 7): Rook(withColor: .Black),
            Square(row: 1, column: 1): Pawn(withColor: .Black),
            Square(row: 1, column: 2): Pawn(withColor: .Black),
            Square(row: 1, column: 3): Pawn(withColor: .Black),
            Square(row: 2, column: 0): Pawn(withColor: .Black),
            Square(row: 2, column: 4): Pawn(withColor: .Black),
            Square(row: 2, column: 6): Pawn(withColor: .Black),
            Square(row: 3, column: 0): King(withColor: .Black),
            
            Square(row: 3, column: 3): Pawn(withColor: .White),
            Square(row: 4, column: 0): Knight(withColor: .White),
            Square(row: 4, column: 3): Queen(withColor: .White),
            Square(row: 6, column: 0): Pawn(withColor: .White),
            Square(row: 6, column: 1): Pawn(withColor: .White),
            Square(row: 6, column: 2): Pawn(withColor: .White),
            Square(row: 6, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 7, column: 0): Rook(withColor: .White),
            Square(row: 7, column: 4): King(withColor: .White),
            Square(row: 7, column: 5): Bishop(withColor: .White),
            Square(row: 7, column: 7): Rook(withColor: .White)
        ]
        
        XCTAssertEqual(testBoard.gameOutcomeForTurn(.Black), .InPlay)
    }
    
    func testGameOutcomeForTurnPerformance() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        self.measure {
            for _ in 0...1000{
                let _ = testBoard.gameOutcomeForTurn(.White)
            }
        }
    }
}
