//
//  Game.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/1/21.
//

import Foundation

enum GameError: Error {
    case NoPieceAtPosition
}

protocol GameDelegate {
    func gameEndWithWinner(_ winner: PieceColor)
    func gameEndWithStaleMate()
    func player(_ player: Player, finishedMoveWithBoard: Board)
}

class Game{
    var gameDelegate: GameDelegate?
    var playerWhite: Player
    var playerBlack: Player
    
    var currentPlayer: Player
    
    var currentBoard = Board.startingBoard()
    
    var readyToPlay = true
    
    var gameIsOver = false
    
    init(withPlayerWhite: Player, andPlayerBlack: Player) {
        playerWhite = withPlayerWhite
        playerBlack = andPlayerBlack
        currentPlayer = playerWhite
    }
    
    func start(withCompletion: @escaping () -> Void) {
        gameIsOver = false
        DispatchQueue.global(qos: .userInitiated).async {
            while true{
                if !self.readyToPlay{
                    continue
                }
                if self.currentBoard.isCheckMate(forColor: self.currentPlayer.color) {
                    self.gameIsOver = true
                    DispatchQueue.main.async {
                        self.gameDelegate?.gameEndWithWinner(self.currentPlayer.opposingColor())
                    }
                    withCompletion()
                    break
                }
                if self.currentBoard.isStaleMateForTurn(self.currentPlayer.color){
                    self.gameIsOver = true
                    DispatchQueue.main.async {
                        self.gameDelegate?.gameEndWithStaleMate()
                    }
                    withCompletion()
                    break
                }
                if self.gameIsOver{
                    withCompletion()
                    break
                }
                self.playTurnForPlayer(self.currentPlayer)
            }
        }
    }
    
    func playTurnForPlayer(_ player: Player) {
        self.readyToPlay = false
        player.playTurnOnBoard(currentBoard) { nextBoard in
            DispatchQueue.main.async {
                self.gameDelegate?.player(player, finishedMoveWithBoard: nextBoard)
            }
            self.currentBoard = nextBoard
            self.currentPlayer = self.currentPlayer === self.playerWhite ? self.playerBlack : self.playerWhite
            self.readyToPlay = true
        }
    }
    
    func endGame() {
        gameIsOver = true
    }
}
