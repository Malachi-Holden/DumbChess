//
//  ViewController.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/26/21.
//

import UIKit

protocol ChessBoardControllerDelegate {
    func displaySetup()
}

class ChessBoardViewController: UIViewController, HumanInteractor, GameDelegate, ChessBoardViewDelegate, UIAdaptivePresentationControllerDelegate, SetupViewControllerDelegate, GameControlDelegate {
    var delegate: ChessBoardControllerDelegate?
    @IBOutlet weak var chessBoardView: ChessBoardView!
    var currentBoard = Board()
    var human = HumanPlayer(withColor: .White)
    var bot = DumbBotPlayer(withColor: .Black)
    var game: Game?
    var setupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupScreen")
    
    var humanHasChosen = false
    
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        chessBoardView.delegate = self
        chessBoardView.loadBoard(currentBoard, for: .White)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - SetupViewControllerDelegate methods
    
    func onChoosePlayerColor(_ color: PieceColor) {
        human = HumanPlayer(withColor: color)
        bot = DumbBotPlayer(withColor: Piece.opposingColorForColor(color))
        human.humanInteractor = self
        let playerWhite = color == .White ? human : bot
        let playerBlack = color == .Black ? human : bot
        game = Game(withPlayerWhite: playerWhite, andPlayerBlack: playerBlack)
        game?.gameDelegate = self
        currentBoard = game?.currentBoard ?? currentBoard
        chessBoardView.loadBoard(currentBoard, for: color)
        game?.start {}
    }

    
    //MARK: - HumanInteractor methods
    func startHumanTurn(_ onBoard: Board) {
        currentBoard = onBoard
        humanHasChosen = false
    }
    
    func hasHumanChosen() -> Bool {
        return humanHasChosen
    }
    
    func getBoard() -> Board {
        return currentBoard
    }
    
    //MARK: - GameDelegate methods
    func gameEndWithWinner(_ winner: PieceColor) {
        let winnerString = winner == .White ? "White" : "Black"
        showGameEndPopupWithMessage("\(winnerString) won by checkmate")
    }
    
    func gameEndWithStaleMate() {
        showGameEndPopupWithMessage("Draw by stalemate")
    }
    
    func player(_ player: Player, finishedMoveWithBoard: Board) {
        currentBoard = finishedMoveWithBoard
        chessBoardView.loadBoard(currentBoard, for: human.color)
    }
    
    //MARK: - GameControlDelegate methods
    
    func onPlayerResign() {
        game?.endGame()
        let winnerString = human.color == .White ? "Black" : "White"
        showGameEndPopupWithMessage("\(winnerString) won since you resigned")
    }
    
    func onPlayerRequestDraw() {
        bot.shouldAcceptDrawOnBoard(currentBoard) { shouldAccept in
            if shouldAccept{
                self.game?.endGame()
                self.showGameEndPopupWithMessage("Draw accepted")
                return
            }
            
            let alertController = UIAlertController(title: "Draw refused", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - ChessBoardViewDelegate methods
    
    func userWantsToMoveFrom(_ origin: Square, to destination: Square) {
        if game?.gameIsOver ?? false {
            return
        }
        guard let piece = currentBoard.pieces[origin] else {
            return
        }
        let legalMoves = piece.legalMoves(origin, onBoard: currentBoard)
        guard legalMoves.contains(destination) else {
            return
        }
        if let pawn = piece as? Pawn{
            if destination.row == pawn.promotionRow() {
                showPromotionPopup(from: origin, to: destination)
                return
            }
        }
        currentBoard = piece.moveToPosition(destination, fromPosistion: origin, onBoard: currentBoard)
        
        humanHasChosen = true
    }
    
    func isItCurrentTurnForPosition(_ position: Square) -> Bool {
        return !(game?.gameIsOver ?? false) && game?.currentPlayer === human
    }
    
    
    //MARK: - Utility methods
    
    func showPromotionPopup(from: Square, to destination: Square) {
        let alert = UIAlertController(title: "Pawn Promotion", message: "Choose a piece to promote to", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Knight", style: .default, handler: { action in
            self.promotePawnFromPosition(from, to: destination, as: PromotionPiece.Knight)
        }))
        alert.addAction(UIAlertAction(title: "Bishop", style: .default, handler: { action in
            self.promotePawnFromPosition(from, to: destination, as: PromotionPiece.Bishop)
        }))
        alert.addAction(UIAlertAction(title: "Rook", style: .default, handler: { action in
            self.promotePawnFromPosition(from, to: destination, as: PromotionPiece.Rook)
        }))
        alert.addAction(UIAlertAction(title: "Queen", style: .default, handler: { action in
            self.promotePawnFromPosition(from, to: destination, as: PromotionPiece.Queen)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func promotePawnFromPosition(_ position: Square, to destination: Square, as pieceType: PromotionPiece) {
        guard let pawn = currentBoard.pieces[position] as? Pawn else {
            return
        }
        self.currentBoard = pawn.moveToPosition(Square(row: destination.row, column: destination.column, specialInfo: [Pawn.PROMOTION_PIECE_KEY: pieceType.rawValue]), fromPosistion: position, onBoard: self.currentBoard)
        humanHasChosen = true
    }
    
    func showGameEndPopupWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Game end", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.delegate?.displaySetup()
        }))
        present(alertController, animated: true, completion: nil)
    }
}

