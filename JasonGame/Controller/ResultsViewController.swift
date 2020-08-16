//
//  ResultsViewController.swift
//  JasonGame
//
//  Created by Juan Tavera on 8/1/20.
//  Copyright © 2020 Juan Tavera. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    
    // represents the game
    var game: Game?
    
    // represents the teams sorted by score
    var teams: [Team] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignTeams()
        self.teams.sort(by: self.sortTeamByScore)
        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = self
    }
    

    @IBAction func goBackHomeBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "backToHome" {
        }
    }
    
    // sorts the game's team according to highest score
    func sortTeamBasedOnScore() -> [Team] {
        var teams: [Team] = []
        if let game = self.game {
            for t in game.getTeams() {
                var highest = t
                for teams in game.getTeams() {
                    if teams.getScore() > highest.getScore() {
                        highest = teams
                    }
                }
                teams.append(highest)
            }
        }
        return teams
    }
    
    func sortTeamByScore(this: Team, that: Team) -> Bool {
        return this.getScore() > that.getScore()
    }
    
    func assignTeams() {
        if let g = self.game {
            self.teams = g.getTeams()
        }
    }
}

extension ResultsViewController : UITableViewDelegate {
    
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let game = self.game {
            return game.getTotalTeams()
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.resultsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let teamNum = String(self.teams[indexPath.row].getTeamNumber())
        let score = String(self.teams[indexPath.row].getScore())
        cell.textLabel?.text = "\(indexPath.row + 1). Team \(teamNum) Score: \(score)"
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return "Result:"
    }
    
    
}

