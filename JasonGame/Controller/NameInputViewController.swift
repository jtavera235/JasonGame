//
//  NameInputViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/29/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class NameInputViewController: UIViewController {

    // text field that represents the inputted names
    @IBOutlet weak var nameField: UITextField!
    
    // represents the current game ID label
    @IBOutlet weak var gameIdLbl: UILabel!
    
    // represents the user that was passed in the game search
    var user : User?
    
    // represents the game that was found
    var game: Game?
    
    // represents the database service
    var gameService = GameService()
    
    // represents a game's max list of names
    var maxNames: Int?

    // represents the current number of names a user has inputted
    var currentNameCount = 0
    
    // represents the game id for users who searched for the game
    var gameID: String?
    
    // represents the name table view
    @IBOutlet weak var nameTableView: UITableView!
    
    // represents the number of names a user has inputted
    @IBOutlet weak var numberofNamesEnteredLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let g = self.game {
            self.maxNames = g.getMaxNamesPerPlayer()
            self.gameIdLbl.text = g.getGameID()
            self.numberofNamesEnteredLbl.text! = "\(currentNameCount) / \(maxNames ?? -1)"
        }
        self.nameTableView.delegate = self
        self.nameTableView.dataSource = self
        self.nameField.delegate = self
        if self.user?.isCreator == false {
            self.setMaxNames(id: self.gameID!)
            self.numberofNamesEnteredLbl.text! = "\(currentNameCount) / \(maxNames ?? -1)"
        }
        overrideUserInterfaceStyle = .light
    }
    
    
    // dismisses the text view when touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameField.resignFirstResponder()
    }
    
    // adds the inputted name to a user's list of names
    func updateUsersNameList() {
        if let u = self.user {
            if u.getNames().count < self.maxNames! {
                let name = self.nameField.text!
                if name.count < 1 {
                    self.showAlert(title: "Name not allowed", message: "Please do not input an empty name.")
                } else {
                    self.user?.addName(name: name)
                    self.currentNameCount = self.currentNameCount + 1
                    self.updateNamesEnteredLabel()
                }
            } else {
            }
        } else {
            print("user is undefined")
        }
        self.nameField.text = ""
        self.nameTableView.reloadData()
    }
    
    // updates the total number of names text label
    func updateNamesEnteredLabel() {
        self.numberofNamesEnteredLbl.text! = "\(self.currentNameCount) / \(self.maxNames ?? -1)"
    }
    
    // for users that are not hosts, it sets the max number of names based on the what the server returns
    public func setMaxNames(id: String) {
        if let gameID = self.gameID {
            let promise = self.gameService.getGameSettings(id: gameID)
            promise.then({ (result) in
                self.maxNames = result
                self.game?.setMaxNamesPerPerson(max: result)
                self.updateNamesEnteredLabel()
            })
        } else {
            self.showAlert(title: "Something went wrong.", message: "It appears something went wrong. Please try again.")
        }
    }
    
    // take user to the next VC once they are dont writing down the names
    @IBAction func finishedEnteringNames(_ sender: UIButton) {
        if let u = self.user {
            if let g = self.game {
                if u.getNames().count == g.getMaxNamesPerPlayer() {
                    let isGameLocked = self.gameService.isGameClosed(id: g.getGameID())
                    isGameLocked.then({ (isClosed) in
                        if isClosed {
                            self.showAlert(title: "Game is locked.", message: "The game you are trying to join is locked.")
                        } else {
                            self.gameService.addUserToDatabase(game: g, user: u)
                            self.game?.addParticipant(user: self.user!)
                            if u.isUserCreator() {
                               self.updateUsersNameList()
                               self.performSegue(withIdentifier: "goToParticipantsHost", sender: self)
                            } else {
                                self.updateUsersNameList()
                                self.performSegue(withIdentifier: "goToParticipants", sender: self)
                            }
                        }
                    })
                } else {
                    //
                }
            }
        }
    }
    
    // deletes a name that a user did not want
    func deleteName(name: String) {
        if let u = self.user {
            var index = 0
            for n in u.getNames() {
                if n == name {
                    self.user?.deleteName(index: index)
                }
                index = index + 1
            }
        }
    }
    
    
    // passes the appropriate data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "goToParticipantsHost" {
            let destinationVC = segue.destination as! ParticipantsViewHostViewController
            destinationVC.user = self.user
            destinationVC.game = self.game
        } else if segue.identifier == "goToParticipants" {
            let destinationVC = segue.destination as! ParticipantsViewController
            destinationVC.user = self.user
            destinationVC.game = self.game
            destinationVC.gameID = self.gameID
        }
    }
    
    // shows an alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension NameInputViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateUsersNameList()
        textField.resignFirstResponder()
        return true
    }
}

extension NameInputViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.user?.deleteName(index: indexPath.row)
            self.nameTableView.deleteRows(at: [indexPath], with: .automatic)
            self.currentNameCount = self.currentNameCount - 1
            self.updateNamesEnteredLabel()
        }
    }
}

extension NameInputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.user?.getNames().count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.nameTableView.dequeueReusableCell(withIdentifier: "Names", for: indexPath)
        if self.user?.getNames().count == 0 {
            return cell
        }
        cell.textLabel?.text = self.user?.getNames()[indexPath.row]
        return cell
    }
    
    
}
