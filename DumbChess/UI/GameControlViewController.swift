//
//  GameControlViewController.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/12/21.
//

import UIKit
import MaterialComponents

protocol GameControlDelegate {
    func onPlayerResign()
    func onPlayerRequestDraw()
}

class GameControlViewController: UIViewController {

    var delegate: GameControlDelegate?
    
    @IBOutlet weak var resignButton: MDCButton!
    @IBOutlet weak var drawButton: MDCButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scheme = ApplicationScheme.shared.containerScheme
        self.view.tintColor = scheme.colorScheme.onSurfaceColor
        resignButton.applyOutlinedTheme(withScheme: scheme)
        drawButton.applyOutlinedTheme(withScheme: scheme)
    }
    
    @IBAction func resignTapped(_ sender: Any) {
        delegate?.onPlayerResign()
    }
    
    @IBAction func drawTapped(_ sender: Any) {
        delegate?.onPlayerRequestDraw()
    }
}
