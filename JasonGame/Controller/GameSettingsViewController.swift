//
//  GameSettingsViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/29/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class GameSettingsViewController: UIViewController {

    var user: User?
    var game: Game?
    var gameService = GameService()
    
    // represents the number of teams slider
    @IBOutlet weak var numberOfTeamsSlider: UISlider!
    
    // represents the amount of players per team slider
    @IBOutlet weak var numberOfPlayersPerTeamSlider: UISlider!
    
    // represents the number of names per player
    @IBOutlet weak var numberOfNamesPerPlayer: UISlider!
    
    // represents the label for the number of teams
    @IBOutlet weak var numberOfTeamsLbl: UILabel!
    
    // represents the label for the players per team
    @IBOutlet weak var numberOfPlayersPerTeamLbl: UILabel!
    
    // represents the label for the amount of names per player
    @IBOutlet weak var numberOfNamesPerPlayerLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeSlider()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "goToGameID" {
            let destinationVC = segue.destination as! GameIDViewController
            destinationVC.user = self.user
            destinationVC.game = self.game
        }
    }
    

    @IBAction func createGameBtnPressed(_ sender: UIButton) {
        if self.createGame() {
            self.performSegue(withIdentifier: "goToGameID", sender: self)
        }
    }
    
    // creates a new game
    func createGame() -> Bool {
        let gameID = self.game?.generateGameId()
        let totalTeams = Int(self.numberOfTeamsSlider.value)
        let maxPlayersInTeam = Int(self.numberOfPlayersPerTeamSlider.value)
        let maxNamesPerPlayer = Int(self.numberOfNamesPerPlayer.value)
        if let creator = self.user {
            if let id = gameID {
                self.game = Game(gameID: id, totalTeams: totalTeams, maxPlayersPerTeam: maxPlayersInTeam, maxNamesPerPlayer: maxNamesPerPlayer, creator: creator)
            }
            else {
                print("Game ID is nil.")
                return false
            }
        } else {
            print("User creator is nil.")
            return false
        }
        self.saveGameInDB()
        return true
    }
    
    // saves the game in the database
    func saveGameInDB() {
        if let newGame = self.game {
            self.gameService.createGame(game: newGame)
        }
    }
    
    // changes the number of teams label according to the slider value
    @IBAction func numberOfTeamsChanged(_ sender: Any) {
        self.numberOfTeamsLbl.text = String(Int(self.numberOfTeamsSlider.value))
    }
    
    // changes the number of players per team label according to the slider value
    @IBAction func numberOfPlayersPerTeamChanged(_ sender: Any) {
        self.numberOfPlayersPerTeamLbl.text = String(Int(self.numberOfPlayersPerTeamSlider.value))
    }
    
    // changes the number of names per player label according to the slider value
    @IBAction func numberOfNamesPerPlayerChanged(_ sender: Any) {
        self.numberOfNamesPerPlayerLbl.text = String(Int(self.numberOfNamesPerPlayer.value))
    }
    
    // customizes the sliders properties
    func customizeSlider() {
        self.numberOfPlayersPerTeamSlider.minimumTrackTintColor = UIColor.blue
        self.numberOfNamesPerPlayer.minimumTrackTintColor = UIColor.blue
        self.numberOfTeamsSlider.minimumTrackTintColor = UIColor.blue
        self.numberOfNamesPerPlayer.thumbTintColor = UIColor.systemPink
        self.numberOfTeamsSlider.thumbTintColor = UIColor.systemPink
        self.numberOfPlayersPerTeamSlider.thumbTintColor = UIColor.systemPink
    }
}
