//
//  DumbEngineTest.swift
//  DumbChessTests
//
//  Created by Malachi Holden on 8/3/21.
//

import XCTest

@testable import DumbChess

class DumbEngineTest: XCTestCase {
    var engine = DumbEngine()
    var testBoard = Board()

    override func setUpWithError() throws {
        engine = DumbEngine()
        testBoard = Board()
    }

    func testEvaluateBoard() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 7, column: 0): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        let result = engine.evaluateBoard(testBoard, forTurn: .White)
        XCTAssertEqual(result, -Double(INT_MAX))
        

        
        //test stalemate
        // test checkmate for black
        
        // test various material values
    }
    
    func testEvaluateBoardAtDepth() {
        // fen k7/1r6/8/8/8/8/5PPP/6K1 w - - 0 1
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 1, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        var bestEval = engine.evaluateBoard(testBoard, forTurn: .Black, atDepth: 1)
        XCTAssertEqual(bestEval.evaluation, -Double(INT_MAX))
        XCTAssertEqual(bestEval.origin, Square(row: 1, column: 1))
        XCTAssertEqual(bestEval.destination, Square(row: 7, column: 1))
        XCTAssertFalse(testBoard.pieces[Square(row: 0, column: 0)]!.hasMoved)
//        XCTAssertEqual(engine.totalMovesToCompute, 0)
        
        // fen k7/1r6/8/8/8/8/5PPP/6K1 w - - 0 1
        testBoard.pieces = [
            Square(row: 1, column: 7): Bishop(withColor: .Black),
            Square(row: 2, column: 3): King(withColor: .Black),
            Square(row: 2, column: 4): Pawn(withColor: .Black),
            Square(row: 4, column: 4): Pawn(withColor: .White),
            Square(row: 6, column: 6): Rook(withColor: .Black),
            Square(row: 7, column: 0): King(withColor: .White)
        ]
        
        bestEval = engine.evaluateBoard(testBoard, forTurn: .White, atDepth: 2)
        
        XCTAssertEqual(bestEval.evaluation, 0.0)
        XCTAssertEqual(bestEval.origin, Square(row: 4, column: 4))
        XCTAssertEqual(bestEval.destination, Square(row: 3, column: 4))
    }
    
    func testEvaluateBoardAtDepthFindPin() {
        // k7/1q6/8/8/8/8/5K2/2BB4 w - - 0 1
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        let bestEval = engine.evaluateBoard(testBoard, forTurn: .White, atDepth: 4)
        XCTAssertEqual(bestEval.evaluation, 3.0)
        XCTAssertEqual(bestEval.origin, Square(row: 7, column: 3))
        XCTAssertEqual(bestEval.destination, Square(row: 5, column: 5))
    }
    
    func testEvaluateBoard2AtDepthFindPin() {
        // k7/1q6/8/8/8/8/5K2/2BB4 w - - 0 1
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        let bestEval = engine.evaluateBoard2(testBoard, forTurn: .White, atDepth: 4)
        XCTAssertEqual(bestEval.evaluation, 3.0)
        XCTAssertEqual(bestEval.origin, Square(row: 7, column: 3))
        XCTAssertEqual(bestEval.destination, Square(row: 5, column: 5))
    }
    
    func testEvaluateBoardAtDepthFindPin2() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        
        let bestEval = engine.evaluateBoard(testBoard, forTurn: .Black, atDepth: 3)
        XCTAssertEqual(bestEval.evaluation, 3.0)
    }
    
    func testEvaluateBoardAtDepthFindPin3() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 2, column: 2): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        
        let bestEval = engine.evaluateBoard(testBoard, forTurn: .White, atDepth: 2)
        XCTAssertEqual(bestEval.evaluation, 6.0)
        XCTAssertEqual(bestEval.origin, Square(row: 5, column: 5))
        XCTAssertEqual(bestEval.destination, Square(row: 2, column: 2))
    }
    
    func testEvaluateBoardAtDepthFindPin4() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 2, column: 2): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        
        let bestEval = engine.evaluateBoard(testBoard, forTurn: .Black, atDepth: 1)
        XCTAssertEqual(bestEval.evaluation, 6.0)
    }
    
    func testEvaluateBoardAtDepthEarlyCheckmate() {
        // fen k7/1r6/8/8/8/8/5PPP/6K1 w - - 0 1
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 1, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        let bestEval = engine.evaluateBoard(testBoard, forTurn: .Black, atDepth: 3)
        XCTAssertEqual(bestEval.evaluation, -Double(INT_MAX))
        XCTAssertEqual(bestEval.origin, Square(row: 1, column: 1))
        XCTAssertEqual(bestEval.destination, Square(row: 7, column: 1))
    }
    
    func testEvaluateBoardWithPartial() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        let partialEval = engine.evaluateBoard(testBoard, forTurn: .Black, atDepth: 2, withPartialEvaluation: BoardEvaluation(withBoard: testBoard, startingColor: .Black))
        let bestEval = engine.evaluateBoard(testBoard, forTurn: .Black, atDepth: 3, withPartialEvaluation: partialEval)
        XCTAssertEqual(bestEval.evaluation, 3.0)
    }
    
    func testAsyncEvaluateBoardEarlyCheckmate() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 1, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        
        let expectation = expectation(description: "in checkmate")
        engine.asyncEvaluateBoard(testBoard, forTurn: .Black, atDepth: 3) { boardEval in
            XCTAssertEqual(boardEval.evaluation, -Double(INT_MAX))
            XCTAssertEqual(boardEval.origin, Square(row: 1, column: 1))
            XCTAssertEqual(boardEval.destination, Square(row: 7, column: 1))
            XCTAssertFalse(self.testBoard.pieces[Square(row: 0, column: 0)]!.hasMoved)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1000, handler: nil)
    }
    
    func testAsyncEvaluateBoardInCheckmate() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 1, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        let expectation1 = expectation(description: "in checkmate")
        engine.asyncEvaluateBoard(testBoard, forTurn: .Black, atDepth: 1) { boardEval in
            XCTAssertEqual(boardEval.evaluation, -Double(INT_MAX))
            XCTAssertEqual(boardEval.origin, Square(row: 1, column: 1))
            XCTAssertEqual(boardEval.destination, Square(row: 7, column: 1))
            expectation1.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAsyncEvaluateBoardFindPin() {
        //fen k7/1q6/8/8/8/8/5KP1/2BB4 w - - 0 1
        let expectation = expectation(description: "find pin")
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        engine.asyncEvaluateBoard(testBoard, forTurn: .White, atDepth: 4) { boardEval in
            XCTAssertEqual(boardEval.evaluation, 3.0)
            XCTAssertEqual(boardEval.origin, Square(row: 7, column: 3))
            XCTAssertEqual(boardEval.destination, Square(row: 5, column: 5))
            expectation.fulfill()
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testAsyncEvaluateBoardIsFork() {
        // fen 1k6/1p6/8/8/8/5n2/3Q4/6K1 b - - 0 1
        let expectation = expectation(description: "find fork")
        
        testBoard.pieces = [
            Square(row: 0, column: 1): King(withColor: .Black),
            Square(row: 1, column: 1): Pawn(withColor: .Black),
            Square(row: 5, column: 5): Knight(withColor: .Black),
            Square(row: 6, column: 3): Queen(withColor: .White),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        engine.asyncEvaluateBoard(testBoard, forTurn: .White, atDepth: 3) { boardEval in
            XCTAssertEqual(boardEval.evaluation, -4.0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
   }
    
    func testAsyncEvaluateBoardFindFork() {
        // fen 1k6/1p6/8/4n3/8/8/3Q4/6K1 b - - 0 1
        let expectation = expectation(description: "find fork")
        
        testBoard.pieces = [
            Square(row: 0, column: 1): King(withColor: .Black),
            Square(row: 1, column: 1): Pawn(withColor: .Black),
            Square(row: 3, column: 4): Knight(withColor: .Black),
            Square(row: 6, column: 3): Queen(withColor: .White),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        engine.asyncEvaluateBoard(testBoard, forTurn: .Black, atDepth: 3) { boardEval in
            XCTAssertEqual(boardEval.evaluation, -4.0)
            XCTAssertEqual(boardEval.origin, Square(row: 3, column: 4))
            XCTAssertEqual(boardEval.destination, Square(row: 5, column: 5))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAsyncEvaluateBoardFindCheckmate() {
        // fen k7/1r6/8/8/8/8/5PPP/6K1 w - - 0 1
        let expectation = expectation(description: "find checkmate")
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 1, column: 1): Rook(withColor: .Black),
            Square(row: 7, column: 6): King(withColor: .White)
        ]
        
        engine.asyncEvaluateBoard(testBoard, forTurn: .Black, atDepth: 1) { boardEval in
            XCTAssertEqual(boardEval.evaluation, -Double(INT_MAX))
            XCTAssertEqual(boardEval.origin, Square(row: 1, column: 1))
            XCTAssertEqual(boardEval.destination, Square(row: 7, column: 1))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRookWalkdown() {
        // 8/1k6/7R/6R1/8/8/2K5/8 w - - 0 1
        let expectation = expectation(description: "find rook mate")
        
        testBoard.pieces = [
            Square(row: 1, column: 1): King(withColor: .Black),
            Square(row: 2, column: 7): Rook(withColor: .White),
            Square(row: 3, column: 6): Rook(withColor: .White),
            Square(row: 7, column: 0): King(withColor: .White)
        ]
        
        engine.asyncEvaluateBoard(testBoard, forTurn: .White, atDepth: 3) { boardEval in
            XCTAssertEqual(boardEval.evaluation, Double(INT_MAX))
            XCTAssertEqual(boardEval.origin, Square(row: 3, column: 6))
            XCTAssertEqual(boardEval.destination, Square(row: 1, column: 6))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testAsyncEvaluateBoardFindSmotheredMate() {
        // fen 1k6/5r2/8/2q5/8/7n/6PP/4R2K b - - 0 1
        let expectation = expectation(description: "find smothered mate")
        testBoard.pieces = [
            Square(row: 0, column: 1): King(withColor: .Black),
            Square(row: 3, column: 2): Queen(withColor: .Black),
            Square(row: 5, column: 7): Knight(withColor: .Black),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 7, column: 4): Rook(withColor: .White),
            Square(row: 7, column: 7): King(withColor: .White)
        ]

        engine.asyncEvaluateBoard(testBoard, forTurn: .Black, atDepth: 3) { boardEval in
            XCTAssertEqual(boardEval.evaluation, -Double(INT_MAX))
            XCTAssertEqual(boardEval.origin, Square(row: 3, column: 2))
            XCTAssertEqual(boardEval.destination, Square(row: 7, column: 6))
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAsyncDepthRatiosRookWalkdown() {
        let expectation = expectation(description: "find smothered mate")
        testBoard.pieces = [
            Square(row: 0, column: 1): King(withColor: .Black),
            Square(row: 3, column: 2): Queen(withColor: .Black),
            Square(row: 5, column: 7): Knight(withColor: .Black),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
            Square(row: 7, column: 4): Rook(withColor: .White),
            Square(row: 7, column: 7): King(withColor: .White)
        ]

        engine.asyncEvaluateBoard(testBoard, forTurn: .Black, atDepthRatios: [1.0,1.0,1.0]) { boardEval in
            XCTAssertEqual(boardEval.evaluation, -Double(INT_MAX))
            XCTAssertEqual(boardEval.origin, Square(row: 3, column: 2))
            XCTAssertEqual(boardEval.destination, Square(row: 7, column: 6))
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    //MARK: - Performance Tests
    
    func testEvaluateBoardPerformance() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        self.measure {
            let _ = engine.evaluateBoard(testBoard, forTurn: .Black, atDepth: 3)
        }
    }
    
    func testEvaluateBoard2Performance() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        self.measure {
            let _ = engine.evaluateBoard2(testBoard, forTurn: .Black, atDepth: 3)
        }
    }
    
    func testEvaluateBoard2PerformanceDeeper() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        self.measure {
            let _ = engine.evaluateBoard2(testBoard, forTurn: .White, atDepth: 4)
        }
    }
    
    func testAsyncEvaluatePerformance() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 5, column: 5): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        self.measure {
            let expectation = expectation(description: "findPin")
            engine.asyncEvaluateBoard(testBoard, forTurn: .Black, atDepth: 3) { eval in
                expectation.fulfill()
            }
            waitForExpectations(timeout: 5, handler: nil)
        }
    }
    
    func testAsyncEvaluatePerformanceDeeper() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        self.measure {
            let expectation = expectation(description: "findPin")
            engine.asyncEvaluateBoard(testBoard, forTurn: .Black, atDepth: 4) { eval in
                expectation.fulfill()
            }
            waitForExpectations(timeout: 40, handler: nil)
        }
    }
    
    func testAsyncStartingDeeper() {
        var startingBoard = Board.startingBoard()
        startingBoard = startingBoard.pieces[Square(row: 6, column: 4)]!.moveToPosition(Square(row: 4, column: 4), fromPosistion: Square(row: 6, column: 4), onBoard: startingBoard)
        startingBoard = startingBoard.pieces[Square(row: 1, column: 4)]!.moveToPosition(Square(row: 3, column: 4), fromPosistion: Square(row: 6, column: 4), onBoard: startingBoard)
        self.measure {
            let expectation = expectation(description: "findPin")
            engine.asyncEvaluateBoard(startingBoard, forTurn: .Black, atDepth: 4) { eval in
                expectation.fulfill()
            }
            waitForExpectations(timeout: 40, handler: nil)
        }
    }
    
    func testWithPartial() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        let partialEval = engine.evaluateBoard(testBoard, forTurn: .White, atDepth: 4, withPartialEvaluation: BoardEvaluation(withBoard: testBoard, startingColor: .White))
        self.measure {
            let _ = engine.evaluateBoard(testBoard, forTurn: .White, atDepth: 4, withPartialEvaluation: partialEval)
        }
    }
    
    
    
    func testWithRatios() {
        testBoard.pieces = [
            Square(row: 0, column: 0): King(withColor: .Black),
            Square(row: 1, column: 1): Queen(withColor: .Black),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Bishop(withColor: .White),
            Square(row: 6, column: 5): King(withColor: .White)
        ]
        self.measure {
            let expectation = expectation(description: "findPin")
            engine.asyncEvaluateBoard(testBoard, forTurn: .White, atDepthRatios: [1.0,1.0,1.0,0.5]) { eval in
                expectation.fulfill()
            }
            waitForExpectations(timeout: 30, handler: nil)
        }
    }
    
    func testStartingDeeperWithRatios() {
        var startingBoard = Board.startingBoard()
        startingBoard = startingBoard.pieces[Square(row: 6, column: 4)]!.moveToPosition(Square(row: 4, column: 4), fromPosistion: Square(row: 6, column: 4), onBoard: startingBoard)
        startingBoard = startingBoard.pieces[Square(row: 1, column: 4)]!.moveToPosition(Square(row: 3, column: 4), fromPosistion: Square(row: 6, column: 4), onBoard: startingBoard)
        self.measure {
            let expectation = expectation(description: "findPin")
            engine.asyncEvaluateBoard(startingBoard, forTurn: .White, atDepthRatios: [1.0,1.0,1.0,0.5]) { eval in
                expectation.fulfill()
            }
            waitForExpectations(timeout: 30, handler: nil)
        }
    }
    
    func testStartingDeeperWithSmallRatios() {
        var startingBoard = Board.startingBoard()
        startingBoard = startingBoard.pieces[Square(row: 6, column: 4)]!.moveToPosition(Square(row: 4, column: 4), fromPosistion: Square(row: 6, column: 4), onBoard: startingBoard)
        startingBoard = startingBoard.pieces[Square(row: 1, column: 4)]!.moveToPosition(Square(row: 3, column: 4), fromPosistion: Square(row: 6, column: 4), onBoard: startingBoard)
        self.measure {
            let expectation = expectation(description: "findPin")
            engine.asyncEvaluateBoard(startingBoard, forTurn: .White, atDepthRatios: [1.0,1.0,1.0,0.1]) { eval in
                expectation.fulfill()
            }
            waitForExpectations(timeout: 30, handler: nil)
        }
    }
}
