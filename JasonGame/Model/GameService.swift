//
//  GameService.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/26/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import Foundation
import Promises

class GameService {
    
    
    let database = Firebase()
    
    
    // creates a new game
    public func createGame(game: Game) {
        database.createGameInDatabase(gameId: game.getGameID(), game: game)
    }

    // adds a new user to the list of users
    public func addUserToDatabase(game: Game, user: User) {
        self.database.addUser(gameID: game.getGameID(), user: user)
    }
       
    // finds a game based on the passed game Id and sends user to name input screen if game is found
    public func doesGameExist(id: String) -> Promise<Bool> {
        return self.database.doesGameExist(id: id)
    }
    
    // gets the game settings
    public func getGameSettings(id: String) -> Promise<Int> {
        return self.database.getGameSettings(id: id)
    }
    
    // retrieves a game list of participants
    public func getGameParticipants(id: String) -> Promise<[String]> {
        return self.database.getGameParticipants(id: id)
    }
    
    // retrieves a game list of names
    public func getGameNames(id: String) -> Promise<[String]> {
        return self.database.getGameNames(id: id)
    }
    
    // returns whether a game is closed or not
    public func isGameClosed(id: String) -> Promise<Bool> {
        return self.database.getIsClosedStatus(id: id)
    }
    
    // closes the game in the server
    public func closeGame(id: String) {
        self.database.closeGame(id: id)
    }
    
    
    // randomize order of names
    func randomizeNameOrder(game: Game) -> [String] {
        return game.names.shuffled()
    }
    
    // randomizes the order the teams go
    func randomizeTeamOrder(game: Game) -> [Team] {
        return game.getTeams().shuffled()
    }

    
}
