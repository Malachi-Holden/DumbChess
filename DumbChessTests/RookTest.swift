//
//  RookTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 7/28/21.
//

import XCTest

@testable import DumbChess

class RookTest: XCTestCase {
    
    var testRook = Rook(withColor: .White)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testFundamentalMoves() throws {
        let rookMoves = testRook.fundamentalMoves(Square(row: 1, column: 4))
        XCTAssertEqual(rookMoves.count, 14)
        XCTAssertEqual(Set(rookMoves),
                       Set([
                            Square(row: 1, column: 0),Square(row: 1, column: 1),Square(row: 1, column: 2),Square(row: 1, column: 3),Square(row: 1, column: 5),Square(row: 1, column: 6),Square(row: 1, column: 7),Square(row: 0, column: 4),Square(row: 2, column: 4),Square(row: 3, column: 4),Square(row: 4, column: 4),Square(row: 5, column: 4),Square(row: 6, column: 4),Square(row: 7, column: 4)
                       ]))
    }

    func testUnblockedMoves() {
        let board = Board()
        board.pieces = [
            Square(row: 2, column: 3): testRook,
            Square(row: 2, column: 5): Pawn(withColor: .Black),
            Square(row: 3, column: 4): Pawn(withColor: .Black),
            Square(row: 5, column: 2): Pawn(withColor: .Black),
            Square(row: 7, column: 3): Pawn(withColor: .White)
        ]
        
        let rookMoves = testRook.unblockedMoves(Square(row: 2, column: 3), onBoard: board)
        
        XCTAssertEqual(rookMoves.count, 11)
        XCTAssertEqual(Set(rookMoves), Set([Square(row: 0, column: 3),Square(row: 1, column: 3),Square(row: 2, column: 0),Square(row: 2, column: 1),Square(row: 2, column: 2),Square(row: 2, column: 4),Square(row: 2, column: 5),Square(row: 3, column: 3),Square(row: 4, column: 3),Square(row: 5, column: 3),Square(row: 6, column: 3),]))
    }
}
