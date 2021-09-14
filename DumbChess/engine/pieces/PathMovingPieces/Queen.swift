//
//  Queen.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/27/21.
//

import Foundation

class Queen: PathMovingPiece {
    
    override func directions() -> [Square] {
        return Bishop(withColor: color).directions() + Rook(withColor: color).directions()
    }
    
    override func materialValue() -> Int {
        return 10
    }
    
    override func getImageName() -> String {
        return color == .White ? "wQ" : "bQ"
    }
}
