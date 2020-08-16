//
//  Team.swift
//  JasonGame
//
//  Created by Juan Tavera on 5/26/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import Foundation
import UIKit

struct Team {
    var members: [User]
    var score = 0
    var teamNumber = 0
    
    // adds the passesd users to the current team
    mutating func addMembers(users: [User]) {
        self.members = users
    }
    
    
    // randomizes the turn order
    func determineTeamOrder() -> [User] {
        return self.members.shuffled()
    }
    
    // gets the total players in a team
    func getTotalPlayers() -> Int {
        return self.members.count
    }
    
    // adds a player to the team
    mutating func addPlayer(user: User) {
        self.members.append(user)
    }
    
    // shift the players once the turn is over
    mutating func shiftOrder() {
        print("The members list is: ", self.members)
        let shiftedList = self.members.rotate(shift: 1)
        self.setMembers(members: shiftedList)
        print("The members list after shifting is: ", self.members)
    }
    
    // return the first player
    func getFirstPlayer() -> User {
        if self.members.count == 0 {
            return User(name: "NULL", team: -1, names: [], isCreator: false, gameID: "NULL")
        }
        return self.members[0]
    }
    
    // return s member at a specfiic index
    func getPlayerFromIndex(index: Int) -> User {
        return self.members[index]
    }
    
    // returns the participants of a team
    func getMembers() -> [User] {
        return self.members
    }
    
    // increases the teams score
    mutating func increaseScore() {
        self.score = self.score + 1
    }
    
    // returns a teams score
    func getScore() -> Int {
        return self.score
    }
    
    // sets a teams score
    mutating func setScore(score: Int) -> Team {
        return Team(members: self.members, score: score)
    }
    
    
    // sets a team's number
    mutating func setTeamNumber(number: Int) {
        self.teamNumber = number
    }
    
    // sets the list of members
    mutating func setMembers(members: [User]) {
        self.members = members
    }
    
    // returns a tea's number
    func getTeamNumber() -> Int {
        return self.teamNumber
    }
}


/*

 
 
 Add a shadow on the pause button and change the color to the dark blue
 */
