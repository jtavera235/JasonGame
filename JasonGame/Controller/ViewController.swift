//
//  ViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/25/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // username textfield
    @IBOutlet weak var usernameTextField: UITextField!
    
    // represents the current user
    var user : User?
    
    // represents the current game
    var game: Game?

    // represents the label that shows how many names a user has inputted
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        overrideUserInterfaceStyle = .light
    }

    // takes the user to the game settings screen
    @IBAction func createGameBtnPressed(_ sender: UIButton) {
        createUser(isHost: true)
        self.initGame(isHost: true)
        self.performSegue(withIdentifier: "goToGameSettings", sender: self)
    }
    
    // takes user to the game search screen
    @IBAction func joinGameBtnPressed(_ sender: UIButton) {
        createUser(isHost: false)
        self.initGame(isHost: false)
        self.performSegue(withIdentifier: "goToGameSearch", sender: self)
    }
    
    // dismisses the text view when touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
    }
    
    // initilaizes the current user
    func createUser(isHost : Bool) {
        if usernameTextField.text == "" {
            print("Text view cannot be empty")
        }
        if isHost {
            user = User(name: usernameTextField.text!, team: nil, names: [], isCreator: true, gameID: nil)
        } else {
            user = User(name: usernameTextField.text!, team: nil, names: [], isCreator: false, gameID: nil)
        }
    }
    
    // intializes the game
    func initGame(isHost: Bool) {
        if isHost {
            self.game = Game(gameID: "", totalTeams: -1, maxPlayersPerTeam: -1, maxNamesPerPlayer: -1, creator: self.user!)
        } else {
            self.game = Game(gameID: "", totalTeams: -1, maxPlayersPerTeam: -1, maxNamesPerPlayer: -1, creator: User(name: "NULL", team: nil, names: [], isCreator: false, gameID: nil))
        }
    }
    
    // passes the appropriate data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "goToGameSettings" {
            let destinationVC = segue.destination as! GameSettingsViewController
            destinationVC.user = self.user
            destinationVC.game = self.game
        } else if segue.identifier == "goToGameSearch" {
            let destinationVC = segue.destination as! GameSearchViewController
            destinationVC.user = self.user
            destinationVC.game = self.game
        }
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
