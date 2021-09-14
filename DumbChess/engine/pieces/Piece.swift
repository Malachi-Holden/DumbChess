//
//  Piece.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/26/21.
//

import Foundation
import UIKit

enum PieceColor {
    case Black
    case White
}

class Piece: Equatable, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any  {
        let other = type(of: self).init(withColor: color)
        other.hasMoved = hasMoved
        return other
    }
    
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.color == rhs.color && lhs.hasMoved == rhs.hasMoved
    }
    
    var color: PieceColor
    var hasMoved = false
    required init(withColor: PieceColor) {
        color = withColor
    }
    
    //Override
    
    func fundamentalMoves(_ position: Square) -> [Square] {
        return []
    }
    
    func fundamentalCaptures(_ position: Square) -> [Square]  {
        return fundamentalMoves(position)
    }
    
    func unblockedMoves(_ position: Square, onBoard: Board) -> [Square] {
        return []
    }
    
    static func opposingColorForColor(_ color: PieceColor) -> PieceColor {
        return color == .Black ? .White : .Black
    }
    
    func opposingcolor() -> PieceColor {
        return Piece.opposingColorForColor(color)
    }
    
    func moveToPosition(_ position: Square, fromPosistion: Square, onBoard: Board) -> Board {
        let resultBoard = Board()
        resultBoard.pieces = onBoard.pieces
        resultBoard.turn = onBoard.turn + 1
        resultBoard.pieces.removeValue(forKey: fromPosistion)
        let nextPiece = self.copy() as? Piece
        nextPiece?.hasMoved = true
        resultBoard.pieces[position] = nextPiece
        return resultBoard
    }
    
    func legalMoves(_ position: Square, onBoard: Board) -> [Square] {
        var resultMoves = [] as [Square]
        
        for possibleMove in unblockedMoves(position, onBoard: onBoard) {
            let nextBoard = moveToPosition(possibleMove, fromPosistion: position, onBoard: onBoard)
            if !nextBoard.isKingInCheck(kingColor: color) {
                resultMoves.append(possibleMove)
            }
        }
        
        return resultMoves
    }
    
    func materialValue() -> Int {
        return 0
    }
    
    static func multiplierForColor(_ color: PieceColor) -> Double{
        return color == .White ? 1.0 : -1.0
    }
    
    func colorMultiplier() -> Double {
        return Piece.multiplierForColor(color)
    }
    
    func getImage() -> UIImage? {
        return UIImage(named: getImageName())
    }
    
    func getImageName() -> String {
        return ""
    }
}
