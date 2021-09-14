//
//  Pawn.swift
//  DumbChess
//
//  Created by Malachi Holden on 7/28/21.
//

import Foundation

enum PromotionPiece: String {
    case Queen = "QUEEN"
    case Rook = "ROOK"
    case Bishop = "BISHOP"
    case Knight = "KNIGHT"
}

class Pawn: Piece {
    
    static let PROMOTION_PIECE_KEY = "PROMOTION_PIECE_KEY"
    
    var lastTurnMoved = -1
    var lastTurnWasEnpassantable = false
    
    
    override func fundamentalMoves(_ position: Square) -> [Square] {
        let resultPosition = position + pawnDirectionByColor()
        guard resultPosition.isOnBoard() else {
            return []
        }
        return [resultPosition]
    }
    
    override func fundamentalCaptures(_ position: Square) -> [Square] {
        let leftCapture = position + Square(row: 0, column: -1) + pawnDirectionByColor()
        let rightCapture = position + Square(row: 0, column: 1) + pawnDirectionByColor()
        
        var resultPositions = [] as [Square]
        
        if leftCapture.isOnBoard(){
            resultPositions.append(leftCapture)
        }
        if rightCapture.isOnBoard(){
            resultPositions.append(rightCapture)
        }
        return resultPositions
    }
    
    override func unblockedMoves(_ position: Square, onBoard: Board) -> [Square] {
        var resultPositions = [] as [Square]
        
        for forwardMove in fundamentalMoves(position) {
            guard !onBoard.isSquareOccupied(forwardMove) else {
                break
            }
            if forwardMove.row == 0 || forwardMove.row == 7 {
                resultPositions.append(Square(row: forwardMove.row, column: forwardMove.column, specialInfo: [Self.PROMOTION_PIECE_KEY: PromotionPiece.Queen.rawValue]))
                resultPositions.append(Square(row: forwardMove.row, column: forwardMove.column, specialInfo: [Self.PROMOTION_PIECE_KEY: PromotionPiece.Rook.rawValue]))
                resultPositions.append(Square(row: forwardMove.row, column: forwardMove.column, specialInfo: [Self.PROMOTION_PIECE_KEY: PromotionPiece.Bishop.rawValue]))
                resultPositions.append(Square(row: forwardMove.row, column: forwardMove.column, specialInfo: [Self.PROMOTION_PIECE_KEY: PromotionPiece.Knight.rawValue]))
            }
            else{
                resultPositions.append(forwardMove)
            }
            
            
            guard !hasMoved else {
                break
            }
            
            guard let anotherMove = fundamentalMoves(forwardMove).first else {
                break
            }
            guard !onBoard.isSquareOccupied(anotherMove) else {
                break
            }
            resultPositions.append(anotherMove)
        }
        
        for captureSquare in fundamentalCaptures(position) {
            if canEnPassant(captureSquare: captureSquare, onBoard: onBoard) {
                resultPositions.append(captureSquare)
                continue
            }
            guard let opponentPiece = onBoard.pieces[captureSquare] else {
                continue
            }
            guard opponentPiece.color != color else {
                continue
            }
            resultPositions.append(captureSquare)
        }
        
        return resultPositions
    }
    
    func canEnPassant(captureSquare: Square, onBoard: Board) -> Bool {
        let opposingPawnDirection = Pawn(withColor: opposingcolor()).pawnDirectionByColor()
        let positionOfCapturePiece = captureSquare + opposingPawnDirection
        let originOfCapturePiece = captureSquare - opposingPawnDirection
        guard let pawnToCapture = onBoard.pieces[positionOfCapturePiece] as? Pawn else {
            return false
        }
        
        return pawnToCapture.color != color && !onBoard.isSquareOccupied(originOfCapturePiece) && pawnToCapture.lastTurnWasEnpassantable && pawnToCapture.lastTurnMoved == onBoard.turn
    }
    
    override func moveToPosition(_ position: Square, fromPosistion: Square, onBoard: Board) -> Board {
        let nextBoard = super.moveToPosition(position, fromPosistion: fromPosistion, onBoard: onBoard)
        guard let movedPiece = nextBoard.pieces[position] as? Pawn else {
            return nextBoard
        }
        movedPiece.lastTurnMoved = nextBoard.turn
        movedPiece.lastTurnWasEnpassantable = abs(fromPosistion.row - position.row) == 2
        
        //promote pawn
        if let promotionKey = position.specialInfo?[Self.PROMOTION_PIECE_KEY]{
            var promotionPiece: Piece = Queen(withColor: color)
            switch promotionKey {
            case PromotionPiece.Bishop.rawValue:
                    promotionPiece = Bishop(withColor: color)
                    break;
                case PromotionPiece.Knight.rawValue:
                    promotionPiece = Knight(withColor: color)
                case PromotionPiece.Rook.rawValue:
                    promotionPiece = Rook(withColor: color)
                default:
                    break;
            }
            promotionPiece.hasMoved = true
            nextBoard.pieces[position] = promotionPiece
            return nextBoard
        }
        
        // perform en passant
        guard fromPosistion.column != position.column && onBoard.pieces[position] == nil else {
            return nextBoard
        }
        let opponentPosition = Square(row: fromPosistion.row, column: position.column)
        nextBoard.pieces.removeValue(forKey: opponentPosition)
        return nextBoard
    }
    
    func pawnDirectionByColor() -> Square {
        return color == .White ? Square(row: -1, column: 0) : Square(row: 1, column: 0)
    }
    
    func promotionRow() -> Int {
        return color == .White ? 0 : 7
    }
    
    override func materialValue() -> Int {
        return 1
    }
    
    override func getImageName() -> String {
        return color == .White ? "wP" : "bP"
    }
}
