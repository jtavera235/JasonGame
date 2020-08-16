//
//  User.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/26/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import Foundation

struct User {
    var name: String?
    var team: Int?
    var names: [String]?
    var isCreator = false
    var gameID: String?
    
    
    
    // constructor for a user
    init(name: String, team: Int? = nil, names: [String]? = nil, isCreator: Bool! = nil, gameID: String? = nil) {
        self.name = name
        self.team = team
        self.names = names
        self.isCreator = isCreator
        self.gameID = gameID
    }
    
    
    // returns the team number a User is part of
    public func getTeam() -> Int {
        return self.team ?? 0
    }
    
    // returns the names a user inputted
    public func getNames() -> [String] {
        return self.names!
    }
    
    // returns whether a user created a game
    public func isUserCreator() -> Bool {
        return self.isCreator
    }
    
    // returns a user's game Id
    public func getGameId() -> String {
        return self.gameID ?? "NIL"
    }
    
    // sets the game id that a user is going to play
    public mutating func setGameId(gameID: String) {
        self.gameID = gameID
    }
    
    // sets a user's name
    public mutating func setName(name: String) {
        self.name = name.uppercased()
    }
    
    // set's a user's list of names
    public mutating func setNames(names: [String]) {
        self.names = names
    }
    
    // set's a user's current team
    public mutating func setTeam(team: Int) {
        self.team = team
    }
    
    // updates a user's list of names with the passed name
    public mutating func addName(name: String) {
        self.names?.append(name)
    }
    
    // deletes one of the names of a user's list
    public mutating func deleteName(index: Int) {
        self.names?.remove(at: index)
    }
    
    // gets a user's name
    public func getName() -> String {
        return self.name!
    }
}
