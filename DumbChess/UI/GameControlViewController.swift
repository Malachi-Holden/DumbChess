//
//  GameControlViewController.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/12/21.
//

import UIKit

protocol GameControlDelegate {
    func onPlayerResign()
    func onPlayerRequestDraw()
}

class GameControlViewController: UIViewController {

    var delegate: GameControlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resignTapped(_ sender: Any) {
        delegate?.onPlayerResign()
    }
    
    @IBAction func drawTapped(_ sender: Any) {
        delegate?.onPlayerRequestDraw()
    }
}
