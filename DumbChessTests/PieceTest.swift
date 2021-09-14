//
//  PieceTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 7/30/21.
//

import XCTest

@testable import DumbChess

class PieceTest: XCTestCase {
    
    var testPiece = Piece(withColor: .White)
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testMoveToPosition() {
        let prevBoard = Board()
        prevBoard.pieces = [
            Square(row: 0, column: 0): testPiece,
            Square(row: 0, column: 7): Piece(withColor: .Black)
        ]
        
        let nextBoard = testPiece.moveToPosition(Square(row: 7, column: 0), fromPosistion: Square(row: 0, column: 0), onBoard: prevBoard)
        
        XCTAssertEqual(prevBoard.pieces, [
            Square(row: 0, column: 0): testPiece,
            Square(row: 0, column: 7): Piece(withColor: .Black)
        ])
        
        XCTAssertFalse(prevBoard.pieces[Square(row: 0, column: 0)]!.hasMoved)
        
        let expectedPiece = Piece(withColor: .White)
        expectedPiece.hasMoved = true
        
        XCTAssertEqual(nextBoard.pieces, [
            Square(row: 7, column: 0): expectedPiece,
            Square(row: 0, column: 7): Piece(withColor: .Black)
        ])
    }
    
}
