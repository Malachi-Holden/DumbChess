//
//  DumbBotPlayer.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/1/21.
//

import Foundation

class DumbBotPlayer: Player {
    var botDepthEachLayer = [1.0,1.0,0.9,0.1]
    override func playTurnOnBoard(_ onBoard: Board, completion: @escaping (Board) -> Void) {
        let engine = DumbEngine()
        engine.asyncEvaluateBoard(onBoard, forTurn: color, atDepthRatios: ArraySlice(botDepthEachLayer)) { bestEvaluation in
            guard let origin = bestEvaluation.origin else{
                completion(onBoard) // some kind of error?
                return
            }
            guard let destination = bestEvaluation.destination else{
                completion(onBoard) // some kind of error?
                return
            }
            guard let piece = onBoard.pieces[origin] else{
                completion(onBoard) // some kind of error?
                return
            }
            let resultBoard = piece.moveToPosition(destination, fromPosistion: origin, onBoard: onBoard)
            completion(resultBoard)
        }
    }
    
    func shouldAcceptDrawOnBoard(_ onBoard: Board, completion: @escaping (Bool) -> Void){
        let engine = DumbEngine()
        engine.asyncEvaluateBoard(onBoard, forTurn: color, atDepthRatios: ArraySlice(botDepthEachLayer)) { bestEvaluation in
            completion(bestEvaluation.evaluation*Piece.multiplierForColor(self.color) <= 0.0)
        }
    }
}
