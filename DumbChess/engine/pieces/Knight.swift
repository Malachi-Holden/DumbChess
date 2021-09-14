//
//  Knight.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/28/21.
//

import Foundation

class Knight: Piece {
    override func fundamentalMoves(_ position: Square) -> [Square] {
        var resultPositions = [] as [Square]
        
        for possibleDirection in [Square(row: -2, column: -1),Square(row: -2, column: 1),Square(row: -1, column: -2),Square(row: -1, column: 2),Square(row: 1, column: -2),Square(row: 1, column: 2),Square(row: 2, column: -1),Square(row: 2, column: 1)] {
            let possiblePosition = possibleDirection + position
            if 0<=possiblePosition.row && possiblePosition.row < 8 && 0<=possiblePosition.column && possiblePosition.column < 8{
                resultPositions.append(possiblePosition)
            }
        }
        return resultPositions
    }
    
    override func unblockedMoves(_ position: Square, onBoard: Board) -> [Square] {
        var resultPositions = [] as [Square]
        
        for possiblePosition in fundamentalMoves(position){
            guard let piece = onBoard.pieces[possiblePosition] else {
                resultPositions.append(possiblePosition)
                continue
            }
            if piece.color != color {
                resultPositions.append(possiblePosition)
            }
        }
        return resultPositions
    }
    
    override func materialValue() -> Int {
        return 3
    }
    
    override func getImageName() -> String {
        return color == .White ? "wN" : "bN"
    }
}
