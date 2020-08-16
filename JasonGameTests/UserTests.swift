//
//  UserTests.swift
//  JasonGameTests
//
//  Created by Juan Tavera on 5/26/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import XCTest
@testable import JasonGame

class UserTests: XCTestCase {
    
    var user1: User!
    var user2: User!
    var user3: User!
    var nilUser: User!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        user1 = User(name: "JUAN", team: 1, names: ["ELON MUSK", "FRIDA KAHLO"], isCreator: true)
        user2 = User(name: "RILEY", team: 2, names: ["SANDRA BULLOCK", "MICHAEL JORDAN"], isCreator: false)
        user3 = User(name: "DRAKE", team: 3, names: ["COLT BENNET", "VAN BROWN"], isCreator: false)
        nilUser = User(name: "NIL", team: 2, names: [], isCreator: false, gameID: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        user1 = nil
        user2 = nil
        user3 = nil
    }

    // tests the get team method for a user
    func testGetTeam() {
        XCTAssert(user1.getTeam() == 1)
        XCTAssert(user2.getTeam() == 2)
        XCTAssert(user3.getTeam() == 3)
        
        nilUser.team = nil
        XCTAssert(nilUser.getTeam() == 0)
    }
    
    // test for getting a user's name
    func testGetNames() {
        XCTAssert(user1.getNames() == ["ELON MUSK", "FRIDA KAHLO"])
        XCTAssert(user2.getNames() == ["SANDRA BULLOCK", "MICHAEL JORDAN"])
        XCTAssert(user3.getNames() == ["COLT BENNET", "VAN BROWN"])
    }
    
    // test for determining if a user is a creator
    func testIsCreator() {
        XCTAssert(user1.isUserCreator() == true)
        XCTAssert(user2.isUserCreator() == false)
        XCTAssert(user3.isUserCreator() == false)
    }
    
    // test to set a user's name
    func testSetName() {
        user1.setName(name: "Drake")
        XCTAssert(user1.name == "DRAKE")
        user2.setName(name: "Fred")
        XCTAssert(user2.name == "FRED")
        user3.setName(name: "emily")
        XCTAssert(user3.name == "EMILY")
    }
    
    // test to set a user's list of names
    func testSetNames() {
        let user1Names = ["SASHA", "GREG"]
        user1.setNames(names: user1Names)
        XCTAssert(user1.getNames() == ["SASHA", "GREG"])
        let user2Names = ["CARL"]
        user2.setNames(names: user2Names)
        XCTAssert(user2.getNames() == ["CARL"])
    }
    
    // test to set a user's team
    func testSetTeam() {
        user1.setTeam(team: 3)
        XCTAssert(user1.getTeam() == 3)
        user2.setTeam(team: 6)
        XCTAssert(user2.getTeam() == 6)
    }
    
    // test to get a user's game ID
    func testGetGameID() {
        user1.setGameId(gameID: "ABC")
        XCTAssert(user1.getGameId() == "ABC")
        
        user2.setGameId(gameID: "BBB")
        XCTAssert(user2.getGameId() == "BBB")
    }
    
    // test to set a user's game id
    func testSetGameID() {
        user1.setGameId(gameID: "ABC")
        XCTAssert(user1.getGameId() == "ABC")
        
        user2.setGameId(gameID: "BBB")
        XCTAssert(user2.getGameId() == "BBB")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
