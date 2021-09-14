//
//  Board.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/27/21.
//

import Foundation

enum GameOutcome {
    case Checkmate
    case Stalemate
    case InPlay
}

struct Square: Hashable {
    var row: Int
    var column: Int
    var specialInfo: [String:String]?
    
    static func == (lhs: Square, rhs: Square) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
    
    static func + (left: Square, right:Square) -> Square{
        return Square(row: left.row + right.row, column: left.column + right.column)
    }
    
    static func - (left: Square, right:Square) -> Square{
        return Square(row: left.row - right.row, column: left.column - right.column)
    }
    
    func isOnBoard() -> Bool {
        return 0 <= row && row < 8 && 0 <= column && column < 8
    }
    
    func stringValue() -> String {
        let startingValue = Int(("A" as UnicodeScalar).value) // 65
        guard let scalarValue = UnicodeScalar(column + startingValue) else {
            return ""
        }
        let columnChar = Character(scalarValue)
        return "\(columnChar)\(8 - row)"
    }
}

class Board {
    var turn = 0
    var pieces:[Square: Piece] = [:]
    
    func isSquareOccupied(_ square: Square) -> Bool {
        return pieces[square] != nil
    }
    
    func isKingInCheck(kingColor: PieceColor) -> Bool {
        guard let kingSquare = kingSquareForColor(kingColor) else {
            return false
        }
        guard let king = pieces[kingSquare] else {
            return false
        }
        
        for rookPosition in Rook(withColor: king.color).unblockedMoves(kingSquare, onBoard: self) {
            guard let pieceInDirection = pieces[rookPosition] else{
                continue
            }
            guard ((pieceInDirection as? Rook) != nil || (pieceInDirection as? Queen) != nil) && pieceInDirection.color != kingColor else {
                continue
            }
            return true
        }
        
        for bishopPosition in Bishop(withColor: king.color).unblockedMoves(kingSquare, onBoard: self) {
            guard let pieceInDirection = pieces[bishopPosition] else{
                continue
            }
            guard ((pieceInDirection as? Bishop) != nil || (pieceInDirection as? Queen) != nil) && pieceInDirection.color != kingColor else {
                continue
            }
            return true
        }
        
        for knightSquare in Knight(withColor: king.color).fundamentalMoves(kingSquare) {
            guard let pieceOnSquare = pieces[knightSquare] else{
                continue
            }
            if ((pieceOnSquare as? Knight) != nil) && pieceOnSquare.color != kingColor{
                return true
            }
        }
        
        for pawnSquare in Pawn(withColor: king.color).fundamentalCaptures(kingSquare) {
            guard let pieceOnSquare = pieces[pawnSquare] else{
                continue
            }
            if ((pieceOnSquare as? Pawn) != nil) && pieceOnSquare.color != kingColor{
                return true
            }
        }
        
        for kingSquare in King(withColor: king.color).fundamentalMoves(kingSquare){
            guard let pieceOnSquare = pieces[kingSquare] else{
                continue
            }
            if ((pieceOnSquare as? King) != nil) && pieceOnSquare.color != kingColor{
                return true
            }
        }
        
        return false
    }
    
    func isCheckMate(forColor: PieceColor) -> Bool {
        guard isKingInCheck(kingColor: forColor) else {
            return false
        }
        for (position, piece) in pieces {
            if piece.color == forColor && piece.legalMoves(position, onBoard: self).count > 0 {
                return false
            }
        }
        return true
    }
    
    func isStaleMateForTurn(_ turn: PieceColor) -> Bool {
        guard !isKingInCheck(kingColor: turn) else {
            return false
        }
        for (position, piece) in pieces {
            if piece.color == turn && piece.legalMoves(position, onBoard: self).count > 0 {
                return false
            }
        }
        return true
    }
    
    func gameOutcomeForTurn(_ turn: PieceColor) -> GameOutcome {
        for (position, piece) in pieces {
            if piece.color == turn && piece.legalMoves(position, onBoard: self).count > 0 {
                return .InPlay
            }
        }
        return isKingInCheck(kingColor: turn) ? .Checkmate : .Stalemate
    }
    
    func kingSquareForColor(_ color: PieceColor) -> Square? {
        for (square, piece) in pieces {
            if ((piece as? King) != nil) && piece.color == color {
                return square
            }
        }
        return nil
    }
    
    static func startingBoard() -> Board {
        let resultBoard = Board()
        resultBoard.pieces = [
            //black
            Square(row: 0, column: 0): Rook(withColor: .Black),
            Square(row: 0, column: 1): Knight(withColor: .Black),
            Square(row: 0, column: 2): Bishop(withColor: .Black),
            Square(row: 0, column: 3): Queen(withColor: .Black),
            Square(row: 0, column: 4): King(withColor: .Black),
            Square(row: 0, column: 5): Bishop(withColor: .Black),
            Square(row: 0, column: 6): Knight(withColor: .Black),
            Square(row: 0, column: 7): Rook(withColor: .Black),
            Square(row: 1, column: 0): Pawn(withColor: .Black),
            Square(row: 1, column: 1): Pawn(withColor: .Black),
            Square(row: 1, column: 2): Pawn(withColor: .Black),
            Square(row: 1, column: 3): Pawn(withColor: .Black),
            Square(row: 1, column: 4): Pawn(withColor: .Black),
            Square(row: 1, column: 5): Pawn(withColor: .Black),
            Square(row: 1, column: 6): Pawn(withColor: .Black),
            Square(row: 1, column: 7): Pawn(withColor: .Black),
            //white
            Square(row: 7, column: 0): Rook(withColor: .White),
            Square(row: 7, column: 1): Knight(withColor: .White),
            Square(row: 7, column: 2): Bishop(withColor: .White),
            Square(row: 7, column: 3): Queen(withColor: .White),
            Square(row: 7, column: 4): King(withColor: .White),
            Square(row: 7, column: 5): Bishop(withColor: .White),
            Square(row: 7, column: 6): Knight(withColor: .White),
            Square(row: 7, column: 7): Rook(withColor: .White),
            Square(row: 6, column: 0): Pawn(withColor: .White),
            Square(row: 6, column: 1): Pawn(withColor: .White),
            Square(row: 6, column: 2): Pawn(withColor: .White),
            Square(row: 6, column: 3): Pawn(withColor: .White),
            Square(row: 6, column: 4): Pawn(withColor: .White),
            Square(row: 6, column: 5): Pawn(withColor: .White),
            Square(row: 6, column: 6): Pawn(withColor: .White),
            Square(row: 6, column: 7): Pawn(withColor: .White),
        ]
        return resultBoard
    }
}
