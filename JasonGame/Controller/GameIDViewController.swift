//
//  GameIDViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/29/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class GameIDViewController: UIViewController {

    var game: Game?
    var user: User?
    
    @IBOutlet weak var gameIDLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGameIdLabel()
        // Do any additional setup after loading the view.
    }
    
    // sets the game ID label equal to the game ID
    func setGameIdLabel() {
        if let g = self.game {
            self.gameIDLabel.text = g.getGameID()
        } else {
            print("Game has a null value")
        }
    }

    @IBAction func goToNameInput(_ sender: Any) {
        self.performSegue(withIdentifier: "goToNameInput", sender: self)
    }
    
    // passes the appropriate data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "goToNameInput" {
            let destinationVC = segue.destination as! NameInputViewController
            destinationVC.user = self.user
            destinationVC.game = self.game
        }
    }
    
}
