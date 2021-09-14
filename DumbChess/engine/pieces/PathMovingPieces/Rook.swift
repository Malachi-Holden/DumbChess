//
//  Rook.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/27/21.
//

import Foundation

class Rook: PathMovingPiece {
    
    override func directions() -> [Square] {
        return [Square(row: -1, column: 0),Square(row: 1, column: 0),Square(row: 0, column: -1),Square(row: 0, column: 1)]
    }
    
    override func materialValue() -> Int {
        return 5
    }
    
    override func getImageName() -> String {
        return color == .White ? "wR" : "bR"
    }
}
