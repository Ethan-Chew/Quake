//
//  QuizResultsViewController.swift
//  Quake
//
//  Created by Ethan Chew on 11/9/20.
//

import UIKit

class QuizResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Variables
    let userDefaults = UserDefaults.standard
    var correctQuestions: [String] = []
    var incorrectQuestions: [String] = []
    
    // UI Elements
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var correctQnsLabel: UILabel!
    @IBOutlet weak var returnHomeBtn: UIButton!
    @IBOutlet weak var curvedThing: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Data from User Defaults
        correctQuestions = userDefaults.object(forKey: "Correct Questions") as? [String] ?? [String]()
        incorrectQuestions = userDefaults.object(forKey: "Incorrect Questions") as? [String] ?? [String]()
        
        // Set Amount of correct answers
        correctQnsLabel.text = "\(10 - incorrectQuestions.count)/10"
        
        // Curved Corners
        returnHomeBtn.clipsToBounds = true
        returnHomeBtn.layer.cornerRadius = 20
        curvedThing.clipsToBounds = true
        curvedThing.layer.cornerRadius = 10
        
        // Configure Table View
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        
        if (correctQuestions.contains("Question \(indexPath.row + 1)")) {
            cell.textLabel?.text = "Question \(indexPath.row + 1) = Correct"
        } else if (incorrectQuestions.contains("Question \(indexPath.row + 1)")) {
            cell.textLabel?.text = "Question \(indexPath.row + 1) = Incorrect"
        } else {
            fatalError()
        }

        return cell
    }

    @IBAction func goBackToHome(_ sender: Any) {
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
    
}
