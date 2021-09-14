//
//  King.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/27/21.
//

import Foundation

class King: Piece {
    override func fundamentalMoves(_ position: Square) -> [Square] {
        var resultPositions = [] as [Square]
        
        for possibleDirection in [Square(row: -1, column: -1),Square(row: -1, column: 0),Square(row: -1, column: 1),Square(row: 0, column: -1),Square(row: 0, column: 1),Square(row: 1, column: -1),Square(row: 1, column: 0),Square(row: 1, column: 1)] {
            let possiblePosition = possibleDirection + position
            if 0<=possiblePosition.row && possiblePosition.row < 8 && 0<=possiblePosition.column && possiblePosition.column < 8{
                resultPositions.append(possiblePosition)
            }
        }
        return resultPositions
    }
    
    override func unblockedMoves(_ position: Square, onBoard: Board) -> [Square] {
        var resultPositions = [] as [Square]
        
        for possibleMove in fundamentalMoves(position) {
            if let piece = onBoard.pieces[possibleMove] {
                if piece.color == color {
                    continue
                }
            }
            resultPositions.append(possibleMove)
        }
        
        if let castleSquare = kingsideCastleSquareForPosition(position, onBoard: onBoard) {
            resultPositions.append(castleSquare)
        }
        if let castleSquare = queensideCastleSquareForPosition(position, onBoard: onBoard) {
            resultPositions.append(castleSquare)
        }
        return resultPositions
    }
    
    override func legalMoves(_ position: Square, onBoard: Board) -> [Square] {
        let potentialMoves = super.legalMoves(position, onBoard: onBoard)
        var resultMoves = [] as [Square]
        
        for potentialMove in potentialMoves {
            guard abs(potentialMove.column - position.column) == 2 else {
                //if not castling
                resultMoves.append(potentialMove)
                continue
            }
            // we are castling
            if onBoard.isKingInCheck(kingColor: color) {
                continue
            }
            if potentialMove.column > position.column {
                let potentialBoard = moveToPosition(position + Square(row: 0, column: 1), fromPosistion: position, onBoard: onBoard)
                if potentialBoard.isKingInCheck(kingColor: color) {
                    continue
                }
            }
            if potentialMove.column < position.column {
                let potentialBoard = moveToPosition(position - Square(row: 0, column: 1), fromPosistion: position, onBoard: onBoard)
                if potentialBoard.isKingInCheck(kingColor: color) {
                    continue
                }
            }
            resultMoves.append(potentialMove)
        }
        
        return resultMoves
    }
    
    func kingsideCastleSquareForPosition(_ position: Square, onBoard: Board) -> Square? {
        guard let king = onBoard.pieces[position] else {
            return nil
        }
        guard let kingSideRook = onBoard.pieces[position + Square(row: 0, column: 3)] else{
            return nil
        }
        guard !kingSideRook.hasMoved && !king.hasMoved && kingSideRook.color == color && onBoard.pieces[position+Square(row: 0, column: 1)] == nil else {
            return nil
        }
        let castlePosition = position + Square(row: 0, column: 2)
        return castlePosition.isOnBoard() ? castlePosition : nil
    }
    
    func queensideCastleSquareForPosition(_ position: Square, onBoard: Board) -> Square? {
        guard let king = onBoard.pieces[position] else {
            return nil
        }
        guard let queenSideRook = onBoard.pieces[position - Square(row: 0, column: 4)] else{
            return nil
        }
        guard !queenSideRook.hasMoved && !king.hasMoved && queenSideRook.color == color && onBoard.pieces[position-Square(row: 0, column: 1)] == nil && onBoard.pieces[position-Square(row: 0, column: 2)] == nil else {
            return nil
        }
        let castlePosition = position - Square(row: 0, column: 2)
        return castlePosition.isOnBoard() ? castlePosition : nil
    }
    
    override func moveToPosition(_ position: Square, fromPosistion: Square, onBoard: Board) -> Board {
        let nextBoard = super.moveToPosition(position, fromPosistion: fromPosistion, onBoard: onBoard)
        // castle if necessary
        if position.column - fromPosistion.column == 2 {
            let kingsideRookPos = position + Square(row: 0, column: 1)
            guard let kingsideRook = onBoard.pieces[kingsideRookPos] as? Rook else {
                return nextBoard
            }
            return kingsideRook.moveToPosition(position - Square(row: 0, column: 1), fromPosistion: kingsideRookPos, onBoard: nextBoard)
        }
        guard fromPosistion.column - position.column == 2 else {
            return nextBoard
        }
        let queensideRookPos = position - Square(row: 0, column: 2)
        guard let queensideRook = onBoard.pieces[queensideRookPos] as? Rook else {
            return nextBoard
        }
        return queensideRook.moveToPosition(position + Square(row: 0, column: 1), fromPosistion: queensideRookPos, onBoard: nextBoard)
    }
    
    override func getImageName() -> String {
        return color == .White ? "wK" : "bK"
    }
}
