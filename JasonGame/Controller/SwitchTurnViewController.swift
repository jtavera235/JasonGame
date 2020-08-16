//
//  SwitchTurnViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/29/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class SwitchTurnViewController: UIViewController {
    
    // represents the game
    var game: Game?
    
    // represents the next player to play
    @IBOutlet weak var nextPlayerLbl: UILabel!
    
    // represents how much time is left label
    @IBOutlet weak var timeLeftLbl: UILabel!
    
    @IBOutlet weak var teamOneBox: UILabel!
    
    @IBOutlet weak var teamOneScore: UILabel!
    
    @IBOutlet weak var teamTwoBox: UILabel!
    
    @IBOutlet weak var teamTwoScore: UILabel!
    
    @IBOutlet weak var teamThreeBox: UILabel!
    
    @IBOutlet weak var teamThreeScore: UILabel!
    
    @IBOutlet weak var teamFourBox: UILabel!
    
    @IBOutlet weak var teamFourScore: UILabel!
    
    // represents the timer
    var timer: Timer?
    
    var timeLeft = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTimer()
        self.displayCurrentPlayer()
        self.teamThreeBox.isHidden = true
        self.teamFourBox.isHidden = true
        self.teamThreeScore.isHidden = true
        self.teamFourScore.isHidden = true
        self.displayScoresAndTeams()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // sets up the timer
    func setupTimer() {
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLbl), userInfo: nil, repeats: true)
    }
    
    // displays the current player
    func displayCurrentPlayer() {
        if let game = self.game {
            let player = game.getCurrentTeam().getFirstPlayer().getName()
            let team = game.getCurrentTeam().getTeamNumber()
            self.nextPlayerLbl.text = "Pass device to \(player) - Team \(team)"
        }
    }
    
    // updates the time left label
    @objc func updateTimerLbl() {
        if timeLeft == 0 {
            self.timer?.invalidate()
            self.timer = nil
            self.performSegue(withIdentifier: "backToGame", sender: self)
        } else {
            self.timeLeft = self.timeLeft - 1
            self.timeLeftLbl.text = String(self.timeLeft)
            if self.timeLeft <= 3 {
                self.timeLeftLbl.textColor = UIColor.systemPink
            }
        }
    }
    
    // displays the teams with their scores
    func displayScoresAndTeams() {
        if let game = self.game {
            let numberOfTeams = game.getTotalTeams()
            if numberOfTeams == 3 {
                self.teamThreeBox.isHidden = false
                self.teamThreeScore.isHidden = false
            } else if numberOfTeams == 4 {
                self.teamThreeBox.isHidden = false
                self.teamThreeScore.isHidden = false
                self.teamFourScore.isHidden = false
                self.teamFourBox.isHidden = false
            } else {
            }
            
            for t in game.getTeams() {
                let teamNumber = t.getTeamNumber()
                if teamNumber == 1 {
                    self.teamOneScore.text = String(t.getScore())
                } else if teamNumber == 2 {
                    self.teamTwoScore.text = String(t.getScore())
                } else if teamNumber == 3 {
                    self.teamThreeScore.text = String(t.getScore())
                } else if teamNumber == 4 {
                    self.teamFourScore.text = String(t.getScore())
                } else {
                }
            }
        }
    }
    
    
    @IBAction func skipTimerBtnPressed(_ sender: UIButton) {
        self.timer?.invalidate()
        self.timer = nil
        self.performSegue(withIdentifier: "backToGame", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "backToGame" {
           let destinationVC = segue.destination as! GameScreenViewController
           destinationVC.game = self.game
        }
    }
}
