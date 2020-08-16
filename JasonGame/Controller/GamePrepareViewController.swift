//
//  GamePrepareViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/29/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class GamePrepareViewController: UIViewController {

    // represents a game
    var game: Game?
    
    // represents a game service
    var gameService = GameService()
    
    // represents the label that shows who the first player is
    @IBOutlet weak var firstPlayerLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCurrentTeam()
        self.setLabel()
        if let g = self.game {
            for t in g.getTeams() {
                print(t.getTeamNumber())
            }
        }
    }
    

    // sets the current team of the game
    func setCurrentTeam() {
        let team = self.game?.getTeams()[0]
        self.game?.setCurrentTeam(team: team!)
    }
    
    // sets the label to the first player to go
    func setLabel() {
        let firstTeam = self.game!.getCurrentTeam()
        let name = firstTeam.getFirstPlayer().getName()
        let team = self.game!.getCurrentTeam().getTeamNumber()
        firstPlayerLbl.text! = "Pass the device to \(name) - Team \(team)"
    }
    
    @IBAction func startGamePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToGameScreen", sender: self)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier  == "goToGameScreen" {
               let destinationVC = segue.destination as! GameScreenViewController
               destinationVC.game = self.game
           }
    }

}
