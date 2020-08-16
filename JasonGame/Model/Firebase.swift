//
//  Firebase.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/26/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Promises

class Firebase {
    let db = Firestore.firestore().collection("games")
    
    // Constructor for the database
    init() {
    }
    
    // creates a game in the database
    public func createGameInDatabase(gameId: String, game: Game) {
        let data : [String: Any] = ["id": gameId,
                                    "participants": game.getParticipants(),
                                    "maxNames": game.getMaxNamesPerPlayer(),
                                    "names": [],
                                    "isClosed": false,
                                    "teams" : []]
        let doc = db.document(gameId)
        doc.setData(data) { (error) in
            if let e = error {
                print("there is an error saving the game in the database")
                print(e)
            } else {
                print("Data has been saved")
            }
        }
    }
  
    
    // returns a game object based on the found game
    public func doesGameExist(id: String)  -> Promise<Bool> {
        let doc = db.document(id)
        let promise: Promise<Bool> = Promise<Bool> { (res, err) in
            var doesDocExist: Bool!
            doc.getDocument { (document, error) in
                if let document = document {
                    doesDocExist = document.exists
                    res(doesDocExist)
                } else {
                    doesDocExist = false
                    res(doesDocExist)
                }
            }
        }
        return promise
    }
    
    // adds a user to the firebase game
    public func addUser(gameID: String, user: User) {
        self.addName(gameId: gameID, user: user)
        self.addNames(gameId: gameID, user: user)
    }
    
    // adds a user's inputted names to the firebase game
    public func addNames(gameId: String, user: User) {
        let doc = db.document(gameId)
        doc.updateData(["names" : FieldValue.arrayUnion(user.getNames())])
    }
    
    // adds a user's name to the firebase game
    public func addName(gameId: String, user: User) {
        let doc = db.document(gameId)
        doc.updateData(["participants" : FieldValue.arrayUnion([user.getName()])])
    }
    
    // retrieves a game from the database
    public func getGameSettings(id: String) -> Promise<Int> {
        let doc = db.document(id)
        let settingsPromise = Promise<Int> { (res, err) in
            var maxNames: Int!
            doc.getDocument { (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        maxNames = data["maxNames"] as? Int ?? 0
                        res(maxNames)
                    } else {
                        res(0)
                    }
                }
            }
        }
        return settingsPromise
    }
    
    // retrieves a game most recent participants
    public func getGameParticipants(id: String) -> Promise<[String]> {
        let doc = self.db.document(id)
        let promise = Promise<[String]> { (res, err) in
            var participants: [String]!
            doc.getDocument { (document, err) in
                if let document = document, document.exists {
                    let fbPartic = document.get("participants") as? [String]
                    participants = fbPartic!
                    res(participants)
                    } else {
                        res([])
                    }
                }
        }
        return promise
    }
    
    // retrieves a game list of names
    public func getGameNames(id: String) -> Promise<[String]> {
        let doc = self.db.document(id)
        let promise = Promise<[String]> { (res, err) in
            var names: [String]!
            doc.getDocument { (document, err) in
                if let document = document, document.exists {
                    let data = document.get("names") as? [String]
                    if let d = data {
                        names = d
                        res(names)
                    } else {
                        res([])
                    }
                } else {
                    res([])
                }
            }
        }
        return promise
    }
    
    // retruns whether a game is closed or not
    public func getIsClosedStatus(id: String) -> Promise<Bool> {
         let doc = self.db.document(id)
         let promise = Promise<Bool> { (res, err) in
             var isClosed: Bool!
             doc.getDocument { (document, err) in
                 if let document = document, document.exists {
                     let data = document.get("isClosed") as? Bool
                     if let d = data {
                         isClosed = d
                         res(isClosed)
                     } else {
                         res(false)
                     }
                 } else {
                     res(false)
                 }
             }
         }
         return promise
     }
    
    // closes the game
    public func closeGame(id: String) {
        let doc = db.document(id)
        doc.updateData(["isClosed" : true])
    }
    
    // Uploads the teams from the game
    public func addTeams(id: String, teams: [String]) {
        let doc = db.document(id)
        doc.setData(["teams" : teams])
    }
}
