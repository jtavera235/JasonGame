//
//  GameScreenViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/29/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController {

    // represents the game
    var game: Game?
    
    // represents the game service
    var gameService = GameService()
    
    // represents the current team that is on
    var currentTeam: Team?
    
    // represents the current time left
    @IBOutlet weak var timer: UILabel!
    
    // represents the name label
    @IBOutlet weak var nameLbl: UILabel!
    
    // represents the skip button
    @IBOutlet weak var skipBtn: UIButton!
    
    // represents the next name button
    @IBOutlet weak var nextNameBtn: UIButton!
    
    // represents the currentt player that is playing
    @IBOutlet weak var currentPlayerLbl: UILabel!
    
    // represents the timer class
    var timeLeft: Timer?
    
    // represents the pre turn timer
    var preTurnTime: Timer?
    
    // represents whether tje preActionTimer ended
    var preTimerEnded = false
    
    // represents the time to display
    var timeValue = 5
    
    // represents whether the next name button was tapped twice
    var nextBtnTappedTwice = false
    
    // represents whether the skip button was tapped twice
    var skipBtnTappedTwice = false
    
    // represents whther the timer is paused
    var timerIsPaused = false
    
    // represents whether the turn has ended
    var turnEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skipBtn.isHidden = true
        self.nextNameBtn.isHidden = true
        self.setPreActionTimer()
        self.displayCurrentName()
        self.displayCurrentPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // display the current name
    func displayCurrentName() {
        if self.game?.getNames().count == 0 {
            self.performSegue(withIdentifier: "gameOver", sender: self)
        } else {
            self.nameLbl.text = self.game?.getNames()[0]
        }
    }
    
    // displays the current player playing
    func displayCurrentPlayer() {
        if let game = self.game {
            let player = game.getCurrentTeam().getFirstPlayer().getName()
            let team = game.getCurrentTeam().getTeamNumber()
            self.currentPlayerLbl.text = "\(player) - Team \(team)"
        }
    }
    
    // adds the initial 3 seconds before action is done each turn
    func setPreActionTimer() {
        guard self.preTurnTime == nil else { return }
        self.preTurnTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changePreTurnlabel), userInfo: nil, repeats: true)
    }
    
    // changes the pre turn label
    @objc func changePreTurnlabel() {
        if timeValue == 0 {
            self.preTimerEnded = true
            self.beginTurnTimer()
        } else {
            timeValue = timeValue - 1
            let timerString = String(timeValue)
            self.timer.text = "TURN BEGINS IN \(timerString)"
        }
    }
    
    // sets up the timer
    func beginTurnTimer() {
        self.terminatePreTurnTimer()
        self.displayActions()
        // CHANGE TO 61
        self.timeValue = 10
        self.displayTurnTimer()
    }
    
    // terminates the pre turn timer
    func terminatePreTurnTimer() {
        self.preTurnTime?.invalidate()
        self.preTurnTime = nil
    }
    
    // displays the turn buttons
    func displayActions() {
        if self.preTimerEnded {
            self.nextNameBtn.isHidden = false
            self.skipBtn.isHidden = false
        }
    }
    
    // displays the turn timer
    func displayTurnTimer() {
        guard self.timeLeft == nil else { return }
        self.timeLeft = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeleftLbl), userInfo: nil, repeats: true)
    }
    
    // change turn timer label
    @objc func updateTimeleftLbl() {
        if self.timeValue > 0 {
            self.timeValue = self.timeValue - 1
            self.timer.font = self.timer.font.withSize(60)
            self.timer.text = String(timeValue)
            if self.timeValue <= 5 {
                self.timer.textColor = UIColor.systemPink
            }
        } else {
            self.timeLeft?.invalidate()
            self.timeLeft = nil
            self.endTurn()
        }
    }
    
    // ends the current turn
    func endTurn() {
        self.game?.shiftCurrentTeamOrder()
        self.game?.shiftTeamsOrder()
        self.performSegue(withIdentifier: "switchTurns", sender: self)
    }
    
    // skip button pressed
    @IBAction func skipBtnPressed(_ sender: UIButton) {
        if self.skipBtnTappedTwice {
            if let _ = self.game {
                let names = self.game!.skipName()
                self.game?.setNames(names: names)
            }
            self.displayCurrentName()
            self.skipBtn.setTitle("SKIP", for: .normal)
            self.skipBtnTappedTwice = false
            self.nextBtnTappedTwice = false
            self.nextNameBtn.setTitle("NEXT NAME", for: .normal)
        } else {
            self.skipBtn.setTitle("CONFIRM", for: .normal)
            self.skipBtnTappedTwice = true
            self.nextBtnTappedTwice = false
            self.nextNameBtn.setTitle("NEXT NAME", for: .normal)
        }
    }
    
      // next name button pressed
    @IBAction func nextNameBtnPressed(_ sender: Any) {
        if self.nextBtnTappedTwice {
            self.addPointToTeam()
            self.determineIfGameEnded()
            self.updateCurrentName()
            self.nextNameBtn.setTitle("NEXT NAME", for: .normal)
            self.nextBtnTappedTwice = false
            self.skipBtnTappedTwice = false
            self.skipBtn.setTitle("SKIP", for: .normal)
        } else {
            self.nextBtnTappedTwice = true
            self.nextNameBtn.setTitle("CONFIRM", for: .normal)
            self.skipBtnTappedTwice = false
            self.skipBtn.setTitle("SKIP", for: .normal)
        }
    }
    
    // adds a point to a team
    func addPointToTeam() {
        if let _ = self.game {
            self.game?.increaseTeamScore()
        }
    }
    
    // updates the current name
    func updateCurrentName() {
        if let game = self.game {
            var names = game.getNames()
            names.remove(at: 0)
            self.game?.setNames(names: names)
        }
        self.determineIfGameEnded()
        self.displayCurrentName()
    }
      
    @IBAction func pausePlayTimeBtn(_ sender: UIButton) {
        if self.timerIsPaused {
            self.resumeTurnTimer()
        } else {
            self.pauseTurnTimer()
        }
    }
    
    // pauses the turn timer
    func pauseTurnTimer() {
        if preTimerEnded {
            self.timerIsPaused = true
            self.timeLeft?.invalidate()
            self.timeLeft = nil
            self.nextNameBtn.isHidden = true
            self.skipBtn.isHidden = true
        }
    }
    
    // resumes the turn timer
    func resumeTurnTimer() {
        if preTimerEnded {
            guard self.timeLeft == nil else { return }
            self.timerIsPaused = false
            self.nextNameBtn.isHidden = false
            self.skipBtn.isHidden = false
            self.timeLeft = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeleftLbl), userInfo: nil, repeats: true)
        }
    }
    
    // end game
    func determineIfGameEnded() {
        if let g = self.game {
            if g.getNames().count == 0 {
                self.timeLeft?.invalidate()
                self.timeLeft = nil
                self.performSegue(withIdentifier: "gameOver", sender: self)
            }
        }
    }
    
    
    // passes the appropriate data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "switchTurns" {
            let destinationVC = segue.destination as! SwitchTurnViewController
            destinationVC.game = self.game
        } else if segue.identifier == "gameOver" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.game = self.game
        }
    }
}

extension Array {
    func rotate(shift:Int) -> Array {
        var array = Array()
        if (self.count > 0) {
            array = self
            if (shift > 0) {
                for _ in 1...shift {
                    array.append(array.remove(at: 0))
                }
            }
            else if (shift < 0) {
                for _ in 1...abs(shift) {
                    array.insert(array.remove(at: array.count - 1), at:0)
                }
            }
        }
        return array
    }
}
