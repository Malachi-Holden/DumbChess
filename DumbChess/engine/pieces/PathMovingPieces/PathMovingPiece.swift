//
//  PathMovingPiece.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/28/21.
//

import Foundation

class Path: IteratorProtocol, Sequence {
    
    typealias Element = Square
    
    let directionVector: Square
    
    var currentPosition: Square
    
    init(withDirectionVector: Square, startingPosition: Square) {
        directionVector = withDirectionVector
        currentPosition = startingPosition
    }
    
    func next() -> Square? {
        let nextPosistion = currentPosition + directionVector
        guard nextPosistion.isOnBoard() else{
            return nil
        }
        currentPosition = nextPosistion
        return currentPosition
    }
}

class PathMovingPiece: Piece {
    
    func directions() -> [Square] {
        return []
    }
    
    override func fundamentalMoves(_ position: Square) -> [Square] {
        var resultSquares = [] as [Square]
        for directionVector in directions(){
            for pathPosition in Path(withDirectionVector: directionVector, startingPosition: position) {
                resultSquares.append(pathPosition)
            }
        }
        return resultSquares
    }
    
    override func unblockedMoves(_ position: Square, onBoard: Board) -> [Square] {
        var resultSquares = [] as [Square]
        for directionVector in directions(){
            for pathPosition in Path(withDirectionVector: directionVector, startingPosition: position) {
                guard let pieceInDirection = onBoard.pieces[pathPosition] else{
                    resultSquares.append(pathPosition)
                    continue
                }
                if pieceInDirection.color == color{
                    break
                }
                resultSquares.append(pathPosition)
                break
            }
        }
        return resultSquares
    }
}
