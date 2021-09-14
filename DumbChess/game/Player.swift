//
//  Player.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/1/21.
//

import Foundation

class Player {
    var color: PieceColor
    
    init(withColor: PieceColor) {
        color = withColor
    }
    
    func playTurnOnBoard(_ onBoard: Board, completion: @escaping (Board) -> Void){
        // override in subclasses
    }
    
    func opposingColor() -> PieceColor {
        return Piece.opposingColorForColor(color)
    }
}
