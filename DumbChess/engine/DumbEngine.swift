//
//  DumbEngine.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/26/21.
//

import Foundation

var numberOfComputesRun = 0

class DumbEngine {
    let board = Board()
    var totalMovesToCompute = 0
    var bestPosition: Square?
    var bestMove: Square?
    var evaluation = 0.0
    
    var totalBoardsCalculated = 0
    
    
    func evaluateBoard(_ board:Board, forTurn: PieceColor) -> Double {
        let currentGameOutcome = board.gameOutcomeForTurn(forTurn)
        if currentGameOutcome == .Checkmate{
            return -Piece.multiplierForColor(forTurn) * Double(INT_MAX)
        }
        if currentGameOutcome == .Stalemate {
            return 0
        }
        // take a guess at how good black and white are doing by looking at material advantage and other metrics
        // maybe look at total board control instead of material advantage
        return Double(evaluateMaterialValueForBoard(board)) // for now
    }
    
    func dumbEvaluateBoard(_ board:Board, forTurn: PieceColor) -> Double {
        // take a guess at how good black and white are doing by looking at material advantage and other metrics
        // maybe look at total board control instead of material advantage
        return Double(evaluateMaterialValueForBoard(board)) // for now
    }
    
    func evaluateBoard2(_ board: Board, forTurn: PieceColor, atDepth: Int) -> BoardEvaluation {
        /*
         atDepth: includes black and white moves in depth
         */
        if atDepth == 0 {
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: evaluateBoard(board, forTurn: forTurn))
        }
        
        let currentGameOutcome = board.gameOutcomeForTurn(forTurn)
        
        if currentGameOutcome == .Checkmate{
            let checkmateEvaluation = -Piece.multiplierForColor(forTurn) * Double(INT_MAX)
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: checkmateEvaluation)
        }
        else if currentGameOutcome == .Stalemate{
            let stalemateEvaluation = 0.0
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: stalemateEvaluation)
        }
        let boardEvaluation = BoardEvaluation(withBoard: board, startingColor: forTurn)
        boardEvaluation.computeLegalMovesForColor(forTurn)
        for (position, piece) in board.pieces {

            guard let allLegalMoves = boardEvaluation.legalMovesForPieces[forTurn]?[position] else{
                continue
            }
            for possibleMove in allLegalMoves {
                let possibleBoard = piece.moveToPosition(possibleMove, fromPosistion: position, onBoard: board)

                let engine = DumbEngine()
                let possibleResult = engine.evaluateBoard(possibleBoard, forTurn: Piece.opposingColorForColor(forTurn), atDepth: atDepth - 1)
                if boardEvaluation.destination == nil || boardEvaluation.origin == nil {
                    boardEvaluation.origin = position
                    boardEvaluation.destination = possibleMove
                    boardEvaluation.evaluation = possibleResult.evaluation
                    continue
                }
                let colorMultiplier = Piece.multiplierForColor(forTurn)
                if possibleResult.evaluation * colorMultiplier > boardEvaluation.evaluation * colorMultiplier{
                    boardEvaluation.origin = position
                    boardEvaluation.destination = possibleMove
                    boardEvaluation.evaluation = possibleResult.evaluation
                    continue
                }
            }
        }
        
        return boardEvaluation
    }
    
    func evaluateBoard(_ board: Board, forTurn: PieceColor, atDepth: Int) -> BoardEvaluation {
        /*
         atDepth: includes black and white moves in depth
         */
        if atDepth == 0 {
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: evaluateBoard(board, forTurn: forTurn))
        }
        
        let boardEvaluation = BoardEvaluation(withBoard: board, startingColor: forTurn)
        boardEvaluation.computeLegalMovesForColor(forTurn)
        let currentGameOutcome = boardEvaluation.gameOutcomeForTurn(forTurn)
        
        if currentGameOutcome == .Checkmate{
            let checkmateEvaluation = -Piece.multiplierForColor(forTurn) * Double(INT_MAX)
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: checkmateEvaluation)
        }
        else if currentGameOutcome == .Stalemate{
            let stalemateEvaluation = 0.0
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: stalemateEvaluation)
        }

        self.totalMovesToCompute = boardEvaluation.totalLegalMovesForColors[forTurn] ?? 0
        for (position, piece) in board.pieces {

            guard let allLegalMoves = boardEvaluation.legalMovesForPieces[forTurn]?[position] else{
                continue
            }
            for possibleMove in allLegalMoves {
                let possibleBoard = piece.moveToPosition(possibleMove, fromPosistion: position, onBoard: board)
                self.totalMovesToCompute -= 1
                
                let engine = DumbEngine()
                let possibleResult = engine.evaluateBoard(possibleBoard, forTurn: Piece.opposingColorForColor(forTurn), atDepth: atDepth - 1)
                if boardEvaluation.destination == nil || boardEvaluation.origin == nil {
                    boardEvaluation.origin = position
                    boardEvaluation.destination = possibleMove
                    boardEvaluation.evaluation = possibleResult.evaluation
                    continue
                }
                let colorMultiplier = Piece.multiplierForColor(forTurn)
                if possibleResult.evaluation * colorMultiplier > boardEvaluation.evaluation * colorMultiplier{
                    boardEvaluation.origin = position
                    boardEvaluation.destination = possibleMove
                    boardEvaluation.evaluation = possibleResult.evaluation
                    continue
                }
            }
        }
        
        return boardEvaluation
    }
    
    func evaluateBoard(_ board: Board, forTurn: PieceColor, atDepth: Int, withPartialEvaluation: BoardEvaluation) -> BoardEvaluation {
        if atDepth == 0 {
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: evaluateBoard(board, forTurn: forTurn))
        }
        
        let boardEvaluation = withPartialEvaluation
        
        if boardEvaluation.computedDepth == 0 || boardEvaluation.legalMovesForPieces[forTurn]?.count == 0 {
            boardEvaluation.computeLegalMovesForColor(forTurn)
        }
        
        let currentGameOutcome = boardEvaluation.gameOutcomeForTurn(forTurn)
        if currentGameOutcome == .Checkmate{
            let checkmateEvaluation = -Piece.multiplierForColor(forTurn) * Double(INT_MAX)
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: checkmateEvaluation)
        }
        else if currentGameOutcome == .Stalemate{
            let stalemateEvaluation = 0.0
            return BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: stalemateEvaluation)
        }
        
        var totalMovesLeftToCompute = boardEvaluation.totalLegalMovesForColors[forTurn] ?? 0
        for (position, piece) in board.pieces{
            guard let allLegalMoves = boardEvaluation.legalMovesForPieces[forTurn]?[position] else{
                continue
            }
            if boardEvaluation.evaluationsForLegalMoves[position] == nil{
                boardEvaluation.evaluationsForLegalMoves[position] = [:]
            }
            for possibleMove in allLegalMoves {
                let possibleBoard = piece.moveToPosition(possibleMove, fromPosistion: position, onBoard: board)
                totalMovesLeftToCompute -= 1
                var nextLevelEval = BoardEvaluation(withBoard: possibleBoard, startingColor: Piece.opposingColorForColor(forTurn))
                let engine = DumbEngine()
                if boardEvaluation.computedDepth >= 1 {
                    nextLevelEval = boardEvaluation.evaluationsForLegalMoves[position]?[possibleMove] ?? nextLevelEval
                }
                
                let possibleResult = engine.evaluateBoard(possibleBoard, forTurn: Piece.opposingColorForColor(forTurn), atDepth: atDepth - 1, withPartialEvaluation: nextLevelEval)
                
                boardEvaluation.evaluationsForLegalMoves[position]?[possibleMove] = possibleResult
                
                if boardEvaluation.destination == nil || boardEvaluation.origin == nil {
                    boardEvaluation.origin = position
                    boardEvaluation.destination = possibleMove
                    boardEvaluation.evaluation = possibleResult.evaluation
                    continue
                }
                let colorMultiplier = Piece.multiplierForColor(forTurn)
                if possibleResult.evaluation * colorMultiplier > boardEvaluation.evaluation * colorMultiplier{
                    boardEvaluation.origin = position
                    boardEvaluation.destination = possibleMove
                    boardEvaluation.evaluation = possibleResult.evaluation
                    continue
                }
            }
        }
        boardEvaluation.computedDepth = atDepth
        return boardEvaluation
    }
    
    func asyncEvaluateBoard(_ board: Board, forTurn: PieceColor, atDepth: Int, completion: @escaping (BoardEvaluation) -> ()) {
        /*
         atDepth: includes black and white moves in depth
         */
        
        if atDepth == 0{
            completion(BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: evaluateBoard(board, forTurn: forTurn)))
            return
        }
        let gameOutcome = board.gameOutcomeForTurn(forTurn)
        if gameOutcome == .Checkmate{
            let checkmateEvaluation = -Piece.multiplierForColor(forTurn) * Double(INT_MAX)
            
            completion(BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: checkmateEvaluation))
            return
        }
        else if gameOutcome == .Stalemate{
            let stalemateEvaluation = 0.0
            completion(BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: stalemateEvaluation))
        }
        
        DispatchQueue.global(qos: .userInitiated).async{
            let boardEvaluation = BoardEvaluation(withBoard: board, startingColor: forTurn)
            boardEvaluation.computeLegalMovesForColor(forTurn)
            self.totalMovesToCompute = boardEvaluation.totalLegalMovesForColors[forTurn] ?? 0

            for (position, piece) in board.pieces {
                guard let allLegalMoves = boardEvaluation.legalMovesForPieces[forTurn]?[position] else {
                    continue
                }
                for possibleMove in allLegalMoves{

                    let possibleBoard = piece.moveToPosition(possibleMove, fromPosistion: position, onBoard: board)
                    let engine = DumbEngine()
                    engine.asyncEvaluateBoard(possibleBoard, forTurn: Piece.opposingColorForColor(forTurn), atDepth: atDepth - 1) { possibleResult in
                        let colorMultiplier = Piece.multiplierForColor(forTurn)
                        if boardEvaluation.destination == nil || boardEvaluation.origin == nil {
                            boardEvaluation.origin = position
                            boardEvaluation.destination = possibleMove
                            boardEvaluation.evaluation = possibleResult.evaluation
                        }
                        else if possibleResult.evaluation * colorMultiplier > boardEvaluation.evaluation * colorMultiplier{
                            boardEvaluation.origin = position
                            boardEvaluation.destination = possibleMove
                            boardEvaluation.evaluation = possibleResult.evaluation
                        }
                        
                        DispatchQueue.main.async {
                            self.totalMovesToCompute -= 1
                            if self.totalMovesToCompute == 0{
                                completion(boardEvaluation)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func asyncEvaluateBoard(_ board: Board, forTurn: PieceColor, atDepthRatios: ArraySlice<Double>, completion: @escaping (BoardEvaluation) -> ()) {
        
        if Double.random(in: 0..<1) >= (atDepthRatios.first ?? -1.0){
            completion(BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: evaluateBoard(board, forTurn: forTurn)))
            return
        }
        let gameOutcome = board.gameOutcomeForTurn(forTurn)
        if gameOutcome == .Checkmate{
            let checkmateEvaluation = -Piece.multiplierForColor(forTurn) * Double(INT_MAX)
            
            completion(BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: checkmateEvaluation))
            return
        }
        else if gameOutcome == .Stalemate{
            let stalemateEvaluation = 0.0
            completion(BoardEvaluation(withOrigin: nil, andDestination: nil, andEvaluation: stalemateEvaluation))
        }
        
        DispatchQueue.global(qos: .userInitiated).async{
            let boardEvaluation = BoardEvaluation(withBoard: board, startingColor: forTurn)
            boardEvaluation.computeLegalMovesForColor(forTurn)
            self.totalMovesToCompute = boardEvaluation.totalLegalMovesForColors[forTurn] ?? 0

            for (position, piece) in board.pieces {
                guard let allLegalMoves = boardEvaluation.legalMovesForPieces[forTurn]?[position] else {
                    continue
                }
                for possibleMove in allLegalMoves{

                    let possibleBoard = piece.moveToPosition(possibleMove, fromPosistion: position, onBoard: board)
                    let engine = DumbEngine()
                    engine.asyncEvaluateBoard(possibleBoard, forTurn: Piece.opposingColorForColor(forTurn), atDepthRatios: atDepthRatios.dropFirst()) { possibleResult in
                        let colorMultiplier = Piece.multiplierForColor(forTurn)
                        if boardEvaluation.destination == nil || boardEvaluation.origin == nil {
                            boardEvaluation.origin = position
                            boardEvaluation.destination = possibleMove
                            boardEvaluation.evaluation = possibleResult.evaluation
                        }
                        else if possibleResult.evaluation * colorMultiplier > boardEvaluation.evaluation * colorMultiplier{
                            boardEvaluation.origin = position
                            boardEvaluation.destination = possibleMove
                            boardEvaluation.evaluation = possibleResult.evaluation
                        }
                        
                        DispatchQueue.main.async {
                            self.totalMovesToCompute -= 1
                            if self.totalMovesToCompute == 0{
                                completion(boardEvaluation)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func evaluateMaterialValueForBoard(_ board: Board) -> Int {
        var totalValue = 0
        for (_, piece) in board.pieces {
            totalValue += piece.color == .White ? piece.materialValue() : -piece.materialValue()
        }
        return totalValue
    }
}
