//
//  ParticipantsViewHostViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 6/14/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class ParticipantsViewHostViewController: UIViewController {

    // represents the user
    var user: User?
      
    // represents the game
    var game: Game?
    
    // represents the game service
    var gameService = GameService()
    
    // represents the game that was rerieved from the database
    var retrievedGame: Game?
    
    // represents the list of participants pre-game randomization
    var participants: [String] = []
    
    // represents whether the host has randomized the teams yet
    var hasRandomizedTeams = false
    
    // represents the list of names
    var names: [String] = []
    
    // represents the list of players as a 2-D ARRAY
    var players: [[User]]?
    
    // represents the timer
    var timer_func: Timer?
    
    
    // represents the game ID label
    @IBOutlet weak var gameIdLbl: UILabel!
    
    // represents Team 1 table view
    @IBOutlet weak var teamOneTableView: UITableView!
    
    // represents the start button
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameIdLbl.text = self.game?.getGameID()
        self.teamOneTableView.delegate = self
        self.teamOneTableView.dataSource = self
        self.updateParticipants()
        self.timer()
        self.displayCorrectBtnImage()
        overrideUserInterfaceStyle = .light
    }
            
    @IBAction func startGameBtnPressed(_ sender: UIButton) {
        if self.hasRandomizedTeams {
         self.performSegue(withIdentifier: "goToGameInit", sender: self)
        } else {
            self.closeGame()
            self.randomizeGame()
            self.hasRandomizedTeams = true
            self.displayCorrectBtnImage()
        }
    }
    
    // passes the appropriate data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "goToGameInit" {
            let destinationVC = segue.destination as! GamePrepareViewController
            destinationVC.game = self.game
        }
    }
    
    // randomize the players and team
    func randomizeGame() {
        self.setGameNames()
        self.setGameParticipants()
        self.randomizeTheNames()
        self.randomizePlayers()
        self.players = self.game!.flatten()
    }
    
    // randomizes the game's order
    func randomizeTheNames() {
        if let g = self.game {
            let nameOrder = self.gameService.randomizeNameOrder(game: g)
            self.game?.setNames(names: nameOrder)
        }
    }
    
    // Adds each player to a random team and randomizes the players within each team
    func randomizePlayers() {
        self.game!.createTeam()
        self.game!.assignPlayerstoTeam()
        self.game!.randomizeTeam()
        self.game!.assignTeamNumbers()
    }
    
    // fills the list of participants with the data received from the database
    @objc func updateParticipants() {
        if let game = self.game {
            let isGameClosed = self.gameService.isGameClosed(id: game.getGameID())
            isGameClosed.then({ (isClosed) in
                if isClosed == false {
                    let promise = self.gameService.getGameParticipants(id: game.getGameID())
                    promise.then({ (result) in
                        self.participants = result
                        self.teamOneTableView.reloadData()
                    })
                } else {
                    self.teamOneTableView.reloadData()
                }
            })
        }
        self.updateNames()
    }
    
    // continously calls update participants every 2 seconds
    func timer() {
        guard timer_func == nil else { return }
        timer_func = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateParticipants), userInfo: nil, repeats: true)
    }
    
    // stops the network call timer
    func stopTimer() {
        timer_func?.invalidate()
        timer_func = nil
    }
    
    // get the list of names from the participants
    func updateNames() {
        if let game = self.game {
            let promise = self.gameService.getGameNames(id: game.getGameID())
            promise.then { (result) in
                self.names = result
            }
        }
    }
    
    // sets the participants as the game's users
    func setGameParticipants() {
        var userList: [User] = []
        for participant in self.participants {
            let user = User(name: participant, team: -1, names: [], isCreator: false, gameID: self.game?.getGameID())
            userList.append(user)
        }
        self.game?.setParticpants(players: userList)
    }
    
    // sets the names to the game
    func setGameNames() {
        self.game?.setNames(names: self.names)
    }
    
    // closes the game to not allow any more participants
    func closeGame() {
        if let g = self.game {
            self.gameService.closeGame(id: g.getGameID())
        }
    }
    
    // sets the correct button to display
    func displayCorrectBtnImage() {
        if self.hasRandomizedTeams {
            let image = UIImage(named: "StartBlueBtn.png")
            self.startBtn.setBackgroundImage(image, for: .normal)
        }
    }
}

extension ParticipantsViewHostViewController : UITableViewDelegate {
    
}

extension ParticipantsViewHostViewController : UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.hasRandomizedTeams {
            return self.players!.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasRandomizedTeams {
            return self.players![section].count
        }
        return self.participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.teamOneTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if self.hasRandomizedTeams {
            cell.textLabel?.text = self.players![indexPath.section][indexPath.row].getName()
            return cell
        } else {
            cell.textLabel?.text = self.participants[indexPath.row]
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.hasRandomizedTeams {
            let newSection = section + 1
            return "Team \(newSection)"
        }
         return "Players:"
    }
}
