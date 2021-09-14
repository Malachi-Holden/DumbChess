//
//  PawnTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 7/28/21.
//

import XCTest

@testable import DumbChess

class PawnTest: XCTestCase {
    
    var testPawn = Pawn(withColor: .White)
    var testBoard = Board()

    override func setUpWithError() throws {
        testPawn = Pawn(withColor: .White)
        testBoard = Board()
    }

    
    func testFundamentalMoves() {
        
        var pawnMoves = testPawn.fundamentalMoves(Square(row: 6, column: 0))
        XCTAssertEqual(pawnMoves, [Square(row: 5, column: 0)])
        
        pawnMoves = testPawn.fundamentalMoves(Square(row: 0, column: 0))
        XCTAssertEqual(pawnMoves, [])
        
        testPawn.color = .Black
        
        pawnMoves = testPawn.fundamentalMoves(Square(row: 6, column: 0))
        XCTAssertEqual(pawnMoves, [Square(row: 7, column: 0)])
        
        pawnMoves = testPawn.fundamentalMoves(Square(row: 7, column: 0))
        XCTAssertEqual(pawnMoves, [])
    }
    
    func testCanEnPassant1() {
        testPawn.color = .White
        let pawnToKill = Pawn(withColor: .Black)
        testBoard.pieces = [
            Square(row: 1, column: 3): pawnToKill,
        ]
        let currentBoard = pawnToKill.moveToPosition(Square(row: 3, column: 3), fromPosistion: Square(row: 1, column: 3), onBoard: testBoard)
        
        XCTAssertTrue(testPawn.canEnPassant(captureSquare: Square(row: 2, column: 3), onBoard: currentBoard))
        

    }
    
//    func testCanEnPassant2() {
//        testPawn.color = .White
//        let pawnToKill = Pawn(withColor: .Black)
//        //rewrite all these tests for new enpassant functionality
//        testBoard.pieces = [
//            Square(row: 1, column: 2): pawnToKill
//        ]
//        let currentBoard = pawnToKill.moveToPosition(Square(row: 3, column: 3), fromPosistion: Square(row: 1, column: 2), onBoard: testBoard)
//
//        XCTAssertFalse(testPawn.canEnPassant(captureSquare: Square(row: 2, column: 3), onBoard: currentBoard))
//
//    }
    
//    func testCanEnPassant3() {
//        let pawnToKill = Pawn(withColor: .Black)
//        testBoard.pieces = [
//            Square(row: 1, column: 5): pawnToKill
//        ]
//        let currentBoard = pawnToKill.moveToPosition(Square(row: 3, column: 3), fromPosistion: Square(row: 1, column: 5), onBoard: testBoard)
//
//        XCTAssertFalse(testPawn.canEnPassant(captureSquare: Square(row: 2, column: 3), onBoard: currentBoard))
//
//    }
    
    func testCanEnPassant4() {
        testPawn.color = .White
        let pawnToKill = Pawn(withColor: .Black)
        
        testBoard.pieces = [
            Square(row: 1, column: 5): pawnToKill
        ]
        
        let currentBoard = pawnToKill.moveToPosition(Square(row: 3, column: 5), fromPosistion: Square(row: 1, column: 5), onBoard: testBoard)
        
        XCTAssertTrue(testPawn.canEnPassant(captureSquare: Square(row: 2, column: 5), onBoard: currentBoard))
        
    }
    
    func testCanEnPassant5() {
        testPawn.color = .White
        let pawnToKill = Pawn(withColor: .White)
        testBoard.pieces = [
            Square(row: 1, column: 5): pawnToKill
        ]
        
        let currentBoard = pawnToKill.moveToPosition(Square(row: 3, column: 5), fromPosistion: Square(row: 1, column: 5), onBoard: testBoard)
        
        XCTAssertFalse(testPawn.canEnPassant(captureSquare: Square(row: 2, column: 5), onBoard: currentBoard))
        
    }
    
    func testCanEnPassant6() {
        
        testPawn.color = .White
        let pawnToKill = Pawn(withColor: .Black)
        testBoard.pieces = [
            Square(row: 3, column: 5): pawnToKill
        ]
        
        let currentBoard = pawnToKill.moveToPosition(Square(row: 1, column: 5), fromPosistion: Square(row: 3, column: 5), onBoard: testBoard)

        XCTAssertFalse(testPawn.canEnPassant(captureSquare: Square(row: 2, column: 3), onBoard: currentBoard))
        
        
    }
    
    func testCanEnPassant7() {
        
        let pawnToKill = Pawn(withColor: .White)
        testPawn.color = .Black
        
        testBoard.pieces = [
            Square(row: 7, column: 5): pawnToKill
        ]
        
        let currentBoard = pawnToKill.moveToPosition(Square(row: 5, column: 5), fromPosistion: Square(row: 7, column: 5), onBoard: testBoard)

        XCTAssertTrue(testPawn.canEnPassant(captureSquare: Square(row: 6, column: 5), onBoard: currentBoard))
        
    }
    
//    func testCanEnPassant8() {
//
//        let pawnToKill = Pawn(withColor: .White)
//        testPawn.color = .Black
//        testBoard.pieces = [
//            Square(row: 6, column: 5): pawnToKill
//        ]
//
//        let currentBoard = pawnToKill.moveToPosition(Square(row: 4, column: 3), fromPosistion: Square(row: 6, column: 5), onBoard: testBoard)
//
//        XCTAssertFalse(testPawn.canEnPassant(captureSquare: Square(row: 5, column: 3), onBoard: currentBoard))
//    }
    
    func testUnblockedMoves1() {
        testPawn.color = .White
        testPawn.hasMoved = false
        testBoard.pieces = [
            Square(row: 6, column: 3): testPawn,
            Square(row: 5, column: 4): Pawn(withColor: .Black),
            Square(row: 4, column: 2): Pawn(withColor: .Black)
        ]
        let pawnMoves = testPawn.unblockedMoves(Square(row: 6, column: 3), onBoard: testBoard)
        XCTAssertEqual(pawnMoves.count, 3)
        XCTAssertEqual(Set(pawnMoves), Set([Square(row: 5, column: 4), Square(row: 5, column: 3), Square(row: 4, column: 3)]))
        
    }
    
    func testUnblockedMoves2() {
        testPawn.color = .White
        testPawn.hasMoved = true
        let pawnToKill = Pawn(withColor: .Black)
        testBoard.pieces = [
            Square(row: 1, column: 2): pawnToKill,
            Square(row: 2, column: 4): Pawn(withColor: .Black),
            Square(row: 3, column: 3): testPawn
        ]
        let currentBoard = pawnToKill.moveToPosition(Square(row: 3, column: 2), fromPosistion: Square(row: 1, column: 2), onBoard: testBoard)

        let pawnMoves = testPawn.unblockedMoves(Square(row: 3, column: 3), onBoard: currentBoard)
        XCTAssertEqual(pawnMoves.count, 3)
        XCTAssertEqual(Set(pawnMoves), Set([Square(row: 2, column: 2), Square(row: 2, column: 3), Square(row: 2, column: 4)]))
        
    }
    
    
    func testUnblockedMoves3() {
        
        testPawn.color = .Black
        testPawn.hasMoved = true
        testBoard.pieces = [
            Square(row: 4, column: 4): testPawn,
            Square(row: 4, column: 5): Pawn(withColor: .White),
            Square(row: 5, column: 3): Pawn(withColor: .White),
            Square(row: 5, column: 5): Pawn(withColor: .Black)
        ]
        let pawnMoves = testPawn.unblockedMoves(Square(row: 4, column: 4), onBoard: testBoard)
        XCTAssertEqual(pawnMoves.count, 2)
        XCTAssertEqual(Set(pawnMoves), Set([Square(row: 5, column: 3), Square(row: 5, column: 4)]))
    }
    
    func testUnblockedMoves4() {
        testPawn.color = .Black
        testBoard.pieces = [
            Square(row: 6, column: 0): testPawn
        ]
        let pawnMoves = testPawn.unblockedMoves(Square(row: 6, column: 0), onBoard: testBoard)
        XCTAssertEqual(pawnMoves.count, 4)
        XCTAssertEqual(Set(pawnMoves), Set([
            Square(row: 7, column: 0, specialInfo: [Pawn.PROMOTION_PIECE_KEY: PromotionPiece.Queen.rawValue]),
            Square(row: 7, column: 0, specialInfo: [Pawn.PROMOTION_PIECE_KEY: PromotionPiece.Rook.rawValue]),
            Square(row: 7, column: 0, specialInfo: [Pawn.PROMOTION_PIECE_KEY: PromotionPiece.Bishop.rawValue]),
            Square(row: 7, column: 0, specialInfo: [Pawn.PROMOTION_PIECE_KEY: PromotionPiece.Knight.rawValue])
        ]))
    }

    func testMoveToPosition() {
        let testBoard = Board()
        testBoard.pieces = [
            Square(row: 3, column: 0): Pawn(withColor: .Black),
            Square(row: 3, column: 1): testPawn
        ]
        let nextBoard = testPawn.moveToPosition(Square(row: 2, column: 0), fromPosistion: Square(row: 3, column: 1), onBoard: testBoard)
        XCTAssertNil(nextBoard.pieces[Square(row: 3, column: 0)])
        let expectedPawn = Pawn(withColor: .White)
        expectedPawn.hasMoved = true
        XCTAssertEqual(nextBoard.pieces[Square(row: 2, column: 0)], expectedPawn)
    }
    
    func testMoveToPosition2() {
        testBoard.pieces = [
            Square(row: 7, column: 7): King(withColor: .White),
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 0): Pawn(withColor: .Black),
            Square(row: 1, column: 3): Pawn(withColor: .Black),
            Square(row: 3, column: 2): Pawn(withColor: .White),
            Square(row: 0, column: 1): Bishop(withColor: .Black),
            Square(row: 5, column: 5): Bishop(withColor: .White),
        ]
        let nextBoard = testBoard.pieces[Square(row:1,column: 3)]?.moveToPosition(Square(row:3,column: 3), fromPosistion: Square(row:1,column: 3), onBoard: testBoard)
        let finalBoard = nextBoard?.pieces[Square(row:3,column: 2)]?.moveToPosition(Square(row:2,column: 3), fromPosistion: Square(row:3,column: 3), onBoard: testBoard)
        XCTAssertNil(finalBoard?.pieces[Square(row:3,column: 3)])
        testPawn.hasMoved = true
        XCTAssertEqual(finalBoard?.pieces[Square(row:2,column: 3)], testPawn)
    }
    
    func testMoveToPositionPromotion() {
        let testBoard = Board()
        testPawn.color = .Black
        testBoard.pieces = [
            Square(row: 1, column: 0): testPawn
        ]
        let nextBoard = testPawn.moveToPosition(Square(row: 0, column: 0, specialInfo: [Pawn.PROMOTION_PIECE_KEY: PromotionPiece.Bishop.rawValue]), fromPosistion: Square(row: 1, column: 0), onBoard: testBoard)
        let result = nextBoard.pieces[Square(row: 0, column: 0)]
        XCTAssertNotNil(result as? Bishop)
    }
}
