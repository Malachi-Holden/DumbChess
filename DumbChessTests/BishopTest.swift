//
//  BishopTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 7/28/21.
//

import XCTest

@testable import DumbChess

class BishopTest: XCTestCase {

    let testBishop = Bishop(withColor: .White)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testFundamentalMoves() {
        let bishopMoves = testBishop.fundamentalMoves(Square(row: 1, column: 2))
        
        XCTAssertEqual(bishopMoves.count, 6 + 3)
        XCTAssertEqual(Set(bishopMoves),
                       Set([Square(row: 0, column: 1),Square(row: 2, column: 3),Square(row: 3, column: 4),Square(row: 4, column: 5),Square(row: 5, column: 6),Square(row: 6, column: 7),Square(row: 3, column: 0),Square(row: 2, column: 1),Square(row: 0, column: 3)]))
    }

    func testUnblockedMoves() {
        let board = Board()
        board.pieces = [
            Square(row: 3, column: 3): testBishop,
            Square(row: 3, column: 5): Pawn(withColor: .Black),
            Square(row: 4, column: 4): Pawn(withColor: .Black),
            Square(row: 5, column: 1): Pawn(withColor: .White),
            Square(row: 6, column: 0): Pawn(withColor: .Black)
        ]
        
        let bishopMoves = testBishop.unblockedMoves(Square(row: 3, column: 3), onBoard: board)
        
        XCTAssertEqual(bishopMoves.count, 8)
        XCTAssertEqual(Set(bishopMoves), Set([Square(row: 0, column: 0),Square(row: 1, column: 1),Square(row: 2, column: 2),Square(row: 2, column: 4),Square(row: 1, column: 5),Square(row: 0, column: 6),Square(row: 4, column: 2),Square(row: 4, column: 4)]))
    }
}
