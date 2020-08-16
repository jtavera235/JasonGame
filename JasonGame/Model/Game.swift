//
//  Game.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/26/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import Foundation
import UIKit

struct Game {
    var names: [String]
    var gameID: String?
    var participants: [User]
    var teams: [Team]
    let totalTeams: Int
    var maxPlayersPerTeam: Int
    var maxNamesPerPlayer: Int
    let creator: User
    var currentName: String
    var turnsLeft: Int
    var currentTeam: Team
    
    // constructor for a Game
    init(gameID: String, totalTeams: Int, maxPlayersPerTeam: Int, maxNamesPerPlayer: Int, creator: User) {
        // these values are initialized with data constructor passed
        self.gameID = gameID
        self.totalTeams = totalTeams
        self.maxNamesPerPlayer = maxNamesPerPlayer
        self.maxPlayersPerTeam = maxPlayersPerTeam
        self.creator = creator
        
        // Properties not initialized when a game is first created
        self.names = []
        self.participants = []
        self.teams = []
        self.currentName = ""
        self.turnsLeft = 0
        self.currentTeam = Team(members: [])
    }
    
    // generates a random ID which will be the game Id
    func generateGameId() -> String {
        let possibleCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map{_ in possibleCharacters.randomElement()! })
    }
    
    // sets the name for the game
    mutating func setNames(names: [String]) {
        self.names = names
    }
    
    // sets the teams for the game
    mutating func setTeams(teams: [Team]) {
        self.teams = teams
    }
    
    // sets the current name of the list
    mutating func setCurrentName(cName: String) {
        self.currentName = cName
    }
    
    // sets the participants for the game
    mutating func setParticpants(players: [User]) {
        self.participants = players
    }
    
    // sets the amount of turns left in the game
    mutating func setTurnsLeft(turns: Int) {
        self.turnsLeft = turns
    }
    
    // sets the current team that is going
    mutating func setCurrentTeam(team: Team) {
        self.currentTeam = team
    }
    
    // sets the max number of names a person may enter
    mutating func setMaxNamesPerPerson(max: Int) {
        self.maxNamesPerPlayer = max
    }
    
    // sets the game current ID
    mutating func setID(id: String) {
        self.gameID = id
    }
    
    // returns the game Id for the game
    func getGameID() -> String {
        return self.gameID ?? "NULL"
    }
    
    // adds a user to a game's list of participants
    mutating func addParticipant(user: User) {
        self.participants.append(user)
    }
    
    // returns a game's list of teams
    func getTeams() -> [Team] {
        return self.teams
    }
    
    // returns a game current player
    func getCurrentTeam() -> Team {
        return self.currentTeam
    }
    
    // returns the max names per player
    func getMaxNamesPerPlayer() -> Int {
        return self.maxNamesPerPlayer
    }
    
    // returns the total number of teams in the game
    func getTotalTeams() -> Int {
        return self.totalTeams
    }
    
    // returns the max number of players per team
    func getMaxPlayersPerTeam() -> Int {
        return self.maxPlayersPerTeam
    }
    
    // returns the total number of players in the game
    func getTotalNumberOfParticipants() -> Int {
        return self.participants.count
    }
    
    // returns the participants of the game
    func getParticipants() -> [User] {
        return self.participants
    }
    
    // randomizes the list of participants
    mutating func randomizeParticipants() {
        self.participants = self.participants.shuffled()
    }
    
    // assign each participant to a team
    mutating func assignPlayerstoTeam() {
        for u in self.participants {
            self.addPlayerToTeam(user: u)
        }
        self.areTeamSizesCorrect()
    }
    
    // adds a user to a random team
     mutating func addPlayerToTeam(user: User) {
        let index = Int.random(in: 0..<self.totalTeams)
        if (self.teams[index].getTotalPlayers() < self.maxPlayersPerTeam) {
            self.teams[index].addPlayer(user: user)
        } else {
             self.addPlayerToTeam(user: user)
        }
     }
    
    // get the order in which participants will go in
    func getTurnOrder() -> [User] {
        var order: [User] = []
        for team in self.teams {
            for player in team.getMembers() {
                order.append(player)
            }
        }
        return order
    }
    
    // returns a game's name
    func getNames() -> [String] {
        return self.names
    }
    
    // init game's team with empty teams
    mutating func createTeam() {
        for _ in 1...self.totalTeams {
            let team = Team(members: [], score: 0)
            self.addTeam(team: team)
        }
    }

    
    // adds a team to the game
    mutating func addTeam(team: Team) {
        self.teams.append(team)
    }
    
    // returns the game settings as a string
    func toString() {
         print("The creator is \(self.creator), the max number of players per team is \(self.maxPlayersPerTeam), the max names per person is \(self.maxNamesPerPlayer).")
    }
    
    // randomize the game's team order
    mutating func randomizeTeam() {
        self.teams = self.teams.shuffled()
    }
    
    // flatten team players list
    func flatten() -> [[User]] {
        var users: [[User]] = [[]]
        for team in self.teams {
            users.append(team.getMembers())
        }
        users.remove(at: 0)
        return users
    }
    
    // check if team sizes are playable
    mutating func areTeamSizesCorrect() {
        var teamplayersCount : [Int] = []
        for team in self.teams {
            teamplayersCount.append(team.getMembers().count)
        }
        for count in teamplayersCount {
            for count2 in teamplayersCount {
                if count - count2 >= 2 {
                    self.teams = []
                    self.createTeam()
                    self.assignPlayerstoTeam()
                }
            }
        }
    }
    
    // increase a team's score
    mutating func increaseTeamScore() {
        self.teams[0].increaseScore()
    }
    
    // shifts the teams order for the next team
    mutating func shiftTeamsOrder() {
        self.teams = self.teams.rotate(shift: 1)
        self.currentTeam = self.teams[0]
    }
    
    // shifts the current teams order
    mutating func shiftCurrentTeamOrder() {
        self.teams[0].shiftOrder()
    }
    
    // skips a name
    mutating func skipName() -> [String] {
        if self.names.count == 1 {
            return self.names
        }
        let currentName = self.names[0]
        let shuffledNames = self.names.shuffled()
        if shuffledNames[0] == currentName {
            return self.skipName()
        }
        return shuffledNames
    }
    
    // assign each team a team number
    mutating func assignTeamNumbers() {
        var teamNumber = 1
        for index in 0...self.totalTeams - 1 {
            self.teams[index].setTeamNumber(number: teamNumber)
            teamNumber = teamNumber + 1
        }
    }
    
}
