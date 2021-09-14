//
//  SetupViewController.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/11/21.
//

import UIKit
import MaterialComponents

protocol SetupViewControllerDelegate {
    func onChoosePlayerColor(_ color: PieceColor)
}

class SetupViewController: UIViewController {
    
    var delegate: SetupViewControllerDelegate?
    @IBOutlet weak var playAsWhiteButton: MDCButton!
    @IBOutlet weak var playAsBlackButton: MDCButton!
    @IBOutlet weak var playRandomButton: MDCButton!
    
    @IBOutlet weak var container: MDCCard!
    override func viewDidLoad() {
        super.viewDidLoad()
        let scheme = ApplicationScheme.shared.containerScheme
        container.applyTheme(withScheme: scheme)
        self.view.backgroundColor = scheme.colorScheme.backgroundColor
        self.view.tintColor = scheme.colorScheme.onBackgroundColor
        playAsWhiteButton.applyTextTheme(withScheme: scheme)
        playAsBlackButton.applyTextTheme(withScheme: scheme)
        playRandomButton.applyTextTheme(withScheme: scheme)
    }
    

    @IBAction func playAsWhite(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.onChoosePlayerColor(.White)
        }
    }
    
    @IBAction func playAsBlack(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.onChoosePlayerColor(.Black)
        }
    }
    
    @IBAction func playRandomSide(_ sender: Any) {
        let chosenPlayerColor = [PieceColor.White, PieceColor.Black].randomElement() ?? .White
        dismiss(animated: true) {
            self.delegate?.onChoosePlayerColor(chosenPlayerColor)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
