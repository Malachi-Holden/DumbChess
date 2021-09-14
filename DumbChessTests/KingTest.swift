//
//  KingTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 7/31/21.
//

import XCTest

@testable import DumbChess

class KingTest: XCTestCase {

    var testKing = King(withColor: .White)
    var testBoard = Board()
    
    override func setUpWithError() throws {
        testKing = King(withColor: .White)
        testBoard = Board()
    }
    
    func testKingSideCastleSquareForPosition() {
        testKing.hasMoved = true
        let testBoard = Board()
        XCTAssertNil(testKing.kingsideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
        
        testKing.hasMoved = false
        let testRook = Rook(withColor: .White)
        testRook.hasMoved = false
        testBoard.pieces = [
            Square(row: 0, column: 4): testKing,
            Square(row: 0, column: 7): testRook
        ]
        XCTAssertEqual(testKing.kingsideCastleSquareForPosition(Square(row: 0, column: 4), onBoard: testBoard), Square(row: 0, column: 6))
        
        testRook.hasMoved = true
        XCTAssertNil(testKing.kingsideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
        
        testRook.hasMoved = false
        testKing.hasMoved = true
        XCTAssertNil(testKing.kingsideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
        
        testRook.hasMoved = false
        testKing.hasMoved = false
        testRook.color = .Black
        XCTAssertNil(testKing.kingsideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
        
        testKing.hasMoved = false
        testRook.hasMoved = false
        testRook.color = .White
        testKing.color = .White
        testBoard.pieces = [
            Square(row: 0, column: 4): testKing,
            Square(row: 0, column: 5): Bishop(withColor: .White),
            Square(row: 0, column: 7): testRook
        ]
        XCTAssertNil(testKing.kingsideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
    }
    
    func testQueenSideCastleForPosition() {
        testKing.hasMoved = true
        let testBoard = Board()
        XCTAssertNil(testKing.queensideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
        
        testKing.hasMoved = false
        let testRook = Rook(withColor: .White)
        testRook.hasMoved = false
        testBoard.pieces = [
            Square(row: 0, column: 4): testKing,
            Square(row: 0, column: 7): Rook(withColor: .White),
            Square(row: 0, column: 0): testRook
        ]
        XCTAssertEqual(testKing.queensideCastleSquareForPosition(Square(row: 0, column: 4), onBoard: testBoard), Square(row: 0, column: 2))
        
        testRook.hasMoved = true
        XCTAssertNil(testKing.queensideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
        
        testRook.hasMoved = false
        testKing.hasMoved = true
        XCTAssertNil(testKing.queensideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
        
        testRook.hasMoved = false
        testKing.hasMoved = false
        testRook.color = .Black
        XCTAssertNil(testKing.queensideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
        
        testKing.hasMoved = false
        testRook.hasMoved = false
        testRook.color = .White
        testKing.color = .White
        testBoard.pieces = [
            Square(row: 0, column: 4): testKing,
            Square(row: 0, column: 2): Bishop(withColor: .White),
            Square(row: 0, column: 0): testRook
        ]
        XCTAssertNil(testKing.queensideCastleSquareForPosition(Square(row: 0, column: 4), onBoard:testBoard))
    }
    
    func testUnblockedMoves() {
        testKing.hasMoved = true
        let testBoard = Board()
        testBoard.pieces = [
            Square(row: 4, column: 6): Rook(withColor: .Black),
            Square(row: 5, column: 2): testKing,
            Square(row: 5, column: 3): Pawn(withColor: .White),
            Square(row: 6, column: 1): Pawn(withColor: .Black),
        ]
        let kingMoves = testKing.unblockedMoves(Square(row: 5, column: 2), onBoard: testBoard)
        XCTAssertEqual(kingMoves.count, 7)
        XCTAssertEqual(Set(kingMoves), Set([
                                            Square(row: 5, column: 1), Square(row: 6, column: 1), Square(row: 6, column: 2), Square(row: 6, column: 3), Square(row: 4, column: 1), Square(row: 4, column: 2), Square(row: 4, column: 3)
        ]))
    }

    func testLegalMoves() {
        testKing.hasMoved = true
        
        let testBoard = Board()
        
        // fen 8/8/8/8/6r1/2KP4/1p6/8 w - - 0 1
        testBoard.pieces = [
            Square(row: 4, column: 6): Rook(withColor: .Black),
            Square(row: 5, column: 2): testKing,
            Square(row: 5, column: 3): Pawn(withColor: .White),
            Square(row: 6, column: 1): Pawn(withColor: .Black),
        ]
        var kingMoves = testKing.legalMoves(Square(row: 5, column: 2), onBoard: testBoard)
        XCTAssertEqual(kingMoves.count, 4)
        XCTAssertEqual(Set(kingMoves), Set([
                                            Square(row: 5, column: 1), Square(row: 6, column: 1), Square(row: 6, column: 2), Square(row: 6, column: 3)
        ]))
        
        // fen 8/b7/8/8/8/8/8/4K2R w - - 0 1
        testKing.hasMoved = false
        let testRook = Rook(withColor: .White)
        testRook.hasMoved = false
        testBoard.pieces = [
            Square(row: 1, column: 0): Bishop(withColor: .Black),
            Square(row: 7, column: 4): testKing,
            Square(row: 7, column: 7): testRook
        ]
        kingMoves = testKing.legalMoves(Square(row: 7, column: 4), onBoard: testBoard)
        XCTAssertEqual(kingMoves.count, 4)
        XCTAssertEqual(Set(kingMoves), Set([
                                            Square(row: 6, column: 3), Square(row: 6, column: 4), Square(row: 7, column: 3), Square(row: 7, column: 5)
        ]))
        
        // fen 8/8/8/8/8/8/8/4K2R w - - 0 1
        testKing.hasMoved = false
        testRook.hasMoved = false
        testBoard.pieces = [
            Square(row: 7, column: 4): testKing,
            Square(row: 7, column: 7): testRook
        ]
        kingMoves = testKing.legalMoves(Square(row: 7, column: 4), onBoard: testBoard)
        XCTAssertEqual(kingMoves.count, 6)
        XCTAssertEqual(Set(kingMoves), Set([
                                            Square(row: 6, column: 3), Square(row: 6, column: 4), Square(row: 6, column: 5), Square(row: 7, column: 3), Square(row: 7, column: 3), Square(row: 7, column: 5), Square(row: 7, column: 6)
        ]))
    }

    func testMoveToPosition1() {
        testBoard.pieces = [
            Square(row: 7, column: 4): testKing,
            Square(row: 7, column: 7): Rook(withColor: .White)
        ]
        let resultBoard = testKing.moveToPosition(Square(row:7, column: 6), fromPosistion: Square(row: 7, column: 4), onBoard: testBoard)
        let resultRook = Rook(withColor: .White)
        resultRook.hasMoved = true
        let resultKing = King(withColor: .White)
        resultKing.hasMoved = true
        XCTAssertEqual(resultBoard.pieces[Square(row: 7, column: 5)], resultRook)
        XCTAssertEqual(resultBoard.pieces[Square(row: 7, column: 6)], resultKing)
    }
    
    func testMoveToPosition2() {
        testBoard.pieces = [
            Square(row: 7, column: 4): testKing,
            Square(row: 7, column: 0): Rook(withColor: .White)
        ]
        let resultBoard = testKing.moveToPosition(Square(row:7, column: 2), fromPosistion: Square(row: 7, column: 4), onBoard: testBoard)
        let resultRook = Rook(withColor: .White)
        resultRook.hasMoved = true
        let resultKing = King(withColor: .White)
        resultKing.hasMoved = true
        XCTAssertEqual(resultBoard.pieces[Square(row: 7, column: 3)], resultRook)
        XCTAssertEqual(resultBoard.pieces[Square(row: 7, column: 2)], resultKing)
    }
}
