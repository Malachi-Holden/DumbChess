//
//  FlexPaneViewController.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/11/21.
//

import UIKit

class ChessPaneViewController: UIViewController, ChessBoardControllerDelegate {
    @IBOutlet weak var scaleSideSideHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scaleSideSideWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scaleTopBottomWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scaleTopBottomHeightConstraint: NSLayoutConstraint!
    
    var mainPane: ChessBoardViewController?
    var secondaryPane: GameControlViewController?
    
    var setupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupScreen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scheme = ApplicationScheme.shared.containerScheme
        self.view.backgroundColor = scheme.colorScheme.backgroundColor
        self.view.tintColor = scheme.colorScheme.onBackgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        secondaryPane?.delegate = mainPane
        mainPane?.delegate = self
        displaySetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.view.frame.height >= self.view.frame.width {
            setPanesTopBottom()
            return
        }
        setPanesSideBySide()
    }
    
    func displaySetup() {
        setupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupScreen")
        setupViewController.isModalInPresentation = true
        (setupViewController as? SetupViewController)?.delegate = self.mainPane
        present(setupViewController, animated: true, completion: nil)
    }
    
    func setPanesSideBySide() {
        scaleSideSideWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
        scaleSideSideHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
        scaleTopBottomWidthConstraint.priority = UILayoutPriority(rawValue: 1)
        scaleTopBottomHeightConstraint.priority = UILayoutPriority(rawValue: 1)
    }
    
    func setPanesTopBottom(){
        scaleTopBottomWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
        scaleTopBottomHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
        scaleSideSideWidthConstraint.priority = UILayoutPriority(rawValue: 1)
        scaleSideSideHeightConstraint.priority = UILayoutPriority(rawValue: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedMain"{
            mainPane = segue.destination as? ChessBoardViewController
        }
        if segue.identifier == "embedSecondary"{
            secondaryPane = segue.destination as? GameControlViewController
        }
    }
}
