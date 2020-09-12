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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Data from User Defaults
        correctQuestions = userDefaults.object(forKey: "Correct Question") as? [String] ?? [String]()
        incorrectQuestions = userDefaults.object(forKey: "Incorrect Question") as? [String] ?? [String]()
        
        // Set Amount of correct answers
        print(incorrectQuestions)
        correctQnsLabel.text = "\(10 - incorrectQuestions.count)/10"
        
        // Curved Corners
        returnHomeBtn.clipsToBounds = true
        returnHomeBtn.layer.cornerRadius = 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        if (correctQuestions.contains("Question \(indexPath.row)")) {
            cell.textLabel?.text = "Question \(indexPath.row + 1) = Correct"
        } else if (incorrectQuestions.contains("Question \(indexPath.row)")) {
            cell.textLabel?.text = "Question \(indexPath.row + 1) = Incorrect"
        } else {
            fatalError()
        }
        
        return cell
    }

    @IBAction func goBackToHome(_ sender: Any) {
        
    }
    
}
