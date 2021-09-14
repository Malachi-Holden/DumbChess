//
//  KnightTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 8/9/21.
//

import XCTest

@testable import DumbChess

class KnightTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testLegalMoves1() {
        // 1k6/1p6/8/8/8/5n2/3Q4/5K2 b - - 0 1
        let testKnight = Knight(withColor: .Black)
        let testBoard = Board()
        testBoard.pieces = [
            Square(row: 0, column: 1): King(withColor: .Black),
            Square(row: 1, column: 1): Pawn(withColor: .Black),
            Square(row: 5, column: 5): testKnight,
            Square(row: 6, column: 3): Queen(withColor: .White),
            Square(row: 7, column: 5): King(withColor: .White)
        ]
        let allmoves = testKnight.legalMoves(Square(row: 5, column: 5), onBoard: testBoard)
        XCTAssertEqual(allmoves.count, 8)
        XCTAssertEqual(Set(allmoves), Set([
            Square(row: 3, column: 4),Square(row: 3, column: 6),Square(row: 4, column: 3),Square(row: 4, column: 7),Square(row: 6, column: 3),Square(row: 6, column: 7),Square(row: 7, column: 4),Square(row: 7, column: 6),
        ]))
    }

    func testLegalMoves2() {
        // 8/8/8/8/8/5n2/8/8 b - - 0 1
        let testKnight = Knight(withColor: .Black)
        let testBoard = Board()
        testBoard.pieces = [
            Square(row: 5, column: 5): testKnight
        ]
        let allmoves = testKnight.legalMoves(Square(row: 5, column: 5), onBoard: testBoard)
        XCTAssertEqual(allmoves.count, 8)
        XCTAssertEqual(Set(allmoves), Set([
            Square(row: 3, column: 4),Square(row: 3, column: 6),Square(row: 4, column: 3),Square(row: 4, column: 7),Square(row: 6, column: 3),Square(row: 6, column: 7),Square(row: 7, column: 4),Square(row: 7, column: 6),
        ]))
    }
}
