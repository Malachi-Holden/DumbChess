//
//  BoardEvaluation.swift
//  DumbChess
//
//  Created by Malachi Holden on 8/11/21.
//

import Foundation

enum BoardEvaluationError: Error {
    case NoPieceAtPosition
}

class BoardEvaluation {
    var origin: Square?
    var destination: Square?
    var materialValue = 0
    var evaluation: Double = 0.0
    var legalMovesForPieces:[PieceColor: [Square: [Square]]] = [.White: [:], .Black: [:]]
    var totalLegalMovesForColors = [PieceColor.White: 0, PieceColor.Black: 0];
    var board = Board()
    
    var evaluationsForLegalMoves:[Square:[Square: BoardEvaluation]] = [:]
    var computedDepth = 0
    
    init(withBoard: Board, startingColor: PieceColor) {
        board = withBoard
    }
    
    init(withBoard: Board) {
        board = withBoard
    }
    
    init(withOrigin: Square?, andDestination: Square?, andEvaluation: Double) {
        origin = withOrigin
        destination = andDestination
        evaluation = andEvaluation
    }
    
    func transformFromPosition(_ position: Square, toPosition: Square) throws -> BoardEvaluation {
        //unused
        guard let pieceAtPosition = board.pieces[position] else {
            throw BoardEvaluationError.NoPieceAtPosition
        }
        let transformedEval = BoardEvaluation(withBoard: board, startingColor: pieceAtPosition.opposingcolor())
        transformedEval.computeLegalMovesForColor(pieceAtPosition.opposingcolor()) //remove
        let transformedBoard = pieceAtPosition.moveToPosition(toPosition, fromPosistion: position, onBoard: board)
        transformedEval.board.pieces = transformedBoard.pieces
        transformedEval.board.turn = transformedBoard.turn
        
        // get new material value and allowed moves
        return transformedEval
    }
    
    func gameOutcomeForTurn(_ turn: PieceColor) -> GameOutcome {
        guard let totalLegalMovesForTurn = totalLegalMovesForColors[turn] else {
            return board.isKingInCheck(kingColor: turn) ? .Checkmate : .Stalemate
        }
        
        if totalLegalMovesForTurn == 0 {
            return board.isKingInCheck(kingColor: turn) ? .Checkmate : .Stalemate
        }
        
        return .InPlay
    }
    
    func computeLegalMovesForColor(_ color: PieceColor){
        legalMovesForPieces = [.White:[:], .Black: [:]]
        totalLegalMovesForColors = [.White: 0, .Black: 0]
        for (position, piece) in board.pieces{
            if piece.color != color {
                legalMovesForPieces[piece.color]?[position] = []
                continue
            }
            let allLegalMovesForPiece = piece.legalMoves(position, onBoard: board)
            self.totalLegalMovesForColors[color]? += allLegalMovesForPiece.count
            legalMovesForPieces[color]?[position] = allLegalMovesForPiece
        }
    }
}
