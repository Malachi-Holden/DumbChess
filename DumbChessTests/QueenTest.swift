//
//  QueenTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 8/9/21.
//

import XCTest

@testable import DumbChess

class QueenTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testLegalMoves() {
        let testBoard = Board()
        let testQueen = Queen(withColor: .White)
        testBoard.pieces = [
            Square(row: 0, column: 1): King(withColor: .Black),
            Square(row: 1, column: 1): Pawn(withColor: .Black),
            Square(row: 5, column: 5): Knight(withColor: .Black),
            Square(row: 6, column: 3): testQueen,
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        XCTAssertEqual(testQueen.legalMoves(Square(row: 6, column: 3), onBoard: testBoard).count, 0)
    }

}
