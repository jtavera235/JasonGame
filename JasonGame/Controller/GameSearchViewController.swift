//
//  GameSearchViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/29/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit
import Promises

class GameSearchViewController: UIViewController {

    // represents the user that was created at the initial view controller
    var user : User?
    
    // represents the game that firebase found
    var game: Game?
    
    // represents the game service
    var gameService = GameService()
    
    
    // represents the game ID
    var gameID: String?
    
    // represents the Game ID Text field
    @IBOutlet weak var gameIDTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    // determines what happened if find game was pressed
    @IBAction func findGameBtnPressed(_ sender: UIButton) {
        let id = self.gameIDTextfield.text!
        let gameFound = self.gameService.doesGameExist(id: id)
        gameFound.then({ (p) in
            if p == true {
                let isGameClosed = self.gameService.isGameClosed(id: id)
                isGameClosed.then({(result) in
                    if result == true {
                        self.showAlert(title: "Game is locked.", message: "The game you are trying to join is locked.")
                    } else {
                        self.game?.setID(id: id)
                        self.gameID = id
                        self.performSegue(withIdentifier: "goToNameInput", sender: self)
                    }
                })
            } else {
                self.showAlert(title: "Game not found", message: "The game was not found. Please try again.")
            }
        })
    }

    
    // passes the appropriate data to the next view controller
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier  == "goToNameInput" {
              let destinationVC = segue.destination as! NameInputViewController
            destinationVC.user = self.user
            destinationVC.game = self.game
            destinationVC.gameID = self.gameID!
          }
      }
    
    // dismisses the text view when touched outside
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           gameIDTextfield.resignFirstResponder()
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

extension GameSearchViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gameIDTextfield.resignFirstResponder()
        return true
    }
}
