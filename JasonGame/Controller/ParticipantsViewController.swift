//
//  ParticipantsViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/29/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController {

    // represents the user
    var user: User?
    
    // represents the game
    var game: Game?
    
    // represents a game service
    var gameService = GameService()
    
    // represents the game that was rerieved from the database
    var retrievedGame: Game?
    
    // represents the game ID
    var gameID: String?
    
    // represents the game Id label
    @IBOutlet weak var gameIdLbl: UILabel!
    
    @IBOutlet weak var participantsTableView: UITableView!
    
    var participants: [String] = []
    
    // represents the timer
    var timer_func: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameIdLbl.text = self.game?.getGameID()
        self.participantsTableView.delegate = self
        self.participantsTableView.dataSource = self
        self.updateParticipants()
        self.timer()
        overrideUserInterfaceStyle = .light
    }

    // fills the list of participants with the data received from the database
    @objc func updateParticipants() {
        if let id = self.gameID {
            let isGameClosed = self.gameService.isGameClosed(id: id)
            isGameClosed.then({ (isClosed) in
                if isClosed == false {
                    let promise = self.gameService.getGameParticipants(id: id)
                    promise.then({ (result) in
                        self.participants = result
                        self.participantsTableView.reloadData()
                    })
                } else {
                    self.participantsTableView.reloadData()
                }
            })
        } else {
            print("Game ID is null.")
        }
    }
    
    // continously calls update participants every 2 seconds
    func timer() {
        guard timer_func == nil else { return }
        timer_func = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateParticipants), userInfo: nil, repeats: true)
    }

}

extension ParticipantsViewController : UITableViewDelegate {
    
}

extension ParticipantsViewController : UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.participantsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.participants[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return "Players:"
    }
}
