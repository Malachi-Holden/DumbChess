//
//  ChessBoardView.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/10/21.
//

import UIKit
import MaterialComponents

protocol ChessBoardViewDelegate {
    func userWantsToMoveFrom(_ origin: Square, to destination: Square)
    func isItCurrentTurnForPosition(_ position: Square) -> Bool
}

class PieceButton: UIButton{
    var position: Square?
}

@IBDesignable
class ChessBoardView: MDCCard {
    var delegate: ChessBoardViewDelegate?
    var view: UIView!
    var viewsForPieces = [:] as [Square: UIView]
    var selectedPosition: Square?
    var perspective = PieceColor.White
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for (position, pieceView) in viewsForPieces{
            pieceView.frame = frameForPosition(position)
        }
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        self.view = view
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(boardTapped(sender:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    func placePiece(_ piece: Piece, at position: Square) {
        let pieceView = PieceButton()
        pieceView.position = position
        pieceView.isUserInteractionEnabled = false
        pieceView.setBackgroundImage(piece.getImage(), for: .normal)
        viewsForPieces[position] = pieceView
        pieceView.frame = frameForPosition(position)
        addSubview(pieceView)
    }
    
    func removeAtPosition(_ position: Square) {
        self.viewsForPieces[position]?.removeFromSuperview()
    }
    
    func frameForPosition(_ position: Square) -> CGRect {
        let squareHeight = self.frame.height / 8
        let squareWidth = self.frame.width / 8
        let rawX = perspective == .White ? position.column : 7 - position.column
        let rawY = perspective == .White ? position.row : 7 - position.row
        return CGRect(x: CGFloat(rawX)*squareHeight, y: CGFloat(rawY) * squareWidth, width: squareWidth, height: squareHeight)
    }
    
    func loadBoard(_ board: Board, for perspective: PieceColor) {
        self.perspective = perspective
        for (position, _) in viewsForPieces{
            removeAtPosition(position)
        }
        for (position, piece) in board.pieces{
            placePiece(piece, at: position)
        }
    }
    
    @objc func boardTapped(sender: Any?){
        guard let recognizer = sender as? UITapGestureRecognizer else {
            return
        }
        let tapPoint = recognizer.location(in: self.view)
        // perspective
        let squareHeight = self.frame.height / 8
        let squareWidth = self.frame.width / 8
        var row = Int(tapPoint.y / squareHeight)
        var column = Int(tapPoint.x / squareWidth)
        row = perspective == .White ? row : 7 - row
        column = perspective == .White ? column : 7 - column
        boardTapped(at: Square(row: row, column: column))
    }
    
    func boardTapped(at position: Square) {
        guard delegate?.isItCurrentTurnForPosition(position) ?? false else {
            return
        }
        guard let realizedPosition = selectedPosition else{
            selectedPosition = position
            if let view = viewsForPieces[position]{
                view.backgroundColor = .red
            }
            return
        }
        delegate?.userWantsToMoveFrom(realizedPosition, to: position)
        if let view = viewsForPieces[realizedPosition]{
            view.backgroundColor = .none
        }
        selectedPosition = nil
    }
}
