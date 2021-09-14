//
//  Bishop.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/27/21.
//

import Foundation

class Bishop: PathMovingPiece {
    override func directions() -> [Square] {
        return [Square(row: -1, column: -1), Square(row: -1, column: 1),Square(row: 1, column: -1),Square(row: 1, column: 1)]
    }
    
    override func materialValue() -> Int {
        return 3
    }
    
    override func getImageName() -> String {
        return color == .White ? "wB" : "bB"
    }
}
