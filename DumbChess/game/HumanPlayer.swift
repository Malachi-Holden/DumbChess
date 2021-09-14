//
//  HumanPlayer.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/1/21.
//

import Foundation

protocol HumanInteractor {
    func startHumanTurn(_ onBoard: Board)
    func hasHumanChosen() -> Bool
    func getBoard() -> Board
}

class HumanPlayer: Player {
    var humanInteractor: HumanInteractor?
    override func playTurnOnBoard(_ onBoard: Board, completion: @escaping (Board) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.humanInteractor?.startHumanTurn(onBoard)
            while true{
                guard let hasHumanChosen = self.humanInteractor?.hasHumanChosen() else {
                    return // error?
                }
                if hasHumanChosen {
                    break
                }
            }
            guard let resultBoard = self.humanInteractor?.getBoard() else{
                return // error?
            }
            completion(resultBoard)
        }
    }
}
