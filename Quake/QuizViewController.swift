//
//  QuizViewController.swift
//  Quake
//
//  Created by Ethan Chew on 11/9/20.
//

import UIKit
import CoreXLSX

class QuizViewController: UIViewController {
    
    // UI Elements
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var optionOneBtn: UIButton!
    @IBOutlet weak var optionTwoBtn: UIButton!
    @IBOutlet weak var optionThreeBtn: UIButton!
    @IBOutlet weak var optionFourBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var questionNumber: UILabel!
    
    // Variables
    var data:[String:[String]] = [:]
    var currentQuestionIndex = 1
    var currentQuizAns = ""
    var userPressedOption = ""
    var buttonSelectColour = UIColor(red: 134/255, green: 154/255, blue: 255/255, alpha: 1)
    var correctQuestions: [String] = []
    var incorrectQuestions: [String] = []
    let userDefaults = UserDefaults.standard
    var userDidSelectOption = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Quiz
        getData()
        quizConfig()
        
        // Curved Corners
        optionOneBtn.clipsToBounds = true
        optionTwoBtn.clipsToBounds = true
        optionThreeBtn.clipsToBounds = true
        optionFourBtn.clipsToBounds = true
        submitBtn.clipsToBounds = true
        optionOneBtn.layer.cornerRadius = 10
        optionTwoBtn.layer.cornerRadius = 10
        optionThreeBtn.layer.cornerRadius = 10
        optionFourBtn.layer.cornerRadius = 10
        submitBtn.layer.cornerRadius = 10
    }
    
    // Functions
    func getData() {
        
        // Collect Data
        let worksheetName = "Question Data"
        var randomRowNumber: [Int] = []
        
        do {
            let filepath = Bundle.main.path(forResource: "Quake Data", ofType: "xlsx")!
            
            guard let file = XLSXFile(filepath: filepath) else {
                fatalError("XLSX file at \(filepath) is corrupted or does not exist")
            }
            print("yes")
            
            for wbk in try file.parseWorkbooks() {
                for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                    
                    let sharedStrings = try file.parseSharedStrings()
                    let worksheet = try file.parseWorksheet(at: path)
                    
                    // Pick random row number
                    for i in 1...10 {
                        randomRowNumber.append(Int.random(in: 1...21))
                    }
                    
                    for i in 1...10 {
                        let parseData = worksheet.cells(atRows: [UInt(randomRowNumber[i - 1])])
                            .compactMap { $0.stringValue(sharedStrings) }
                        
                        data["Data \(i)"] = parseData
                    }
                }
            }
            
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func resetButtonColours() {
        optionOneBtn.backgroundColor = UIColor.systemGray
        optionTwoBtn.backgroundColor = UIColor.systemGray
        optionThreeBtn.backgroundColor = UIColor.systemGray
        optionFourBtn.backgroundColor = UIColor.systemGray
    }
    
    func quizConfig() {
        var currentQuizQn: [String] = []
        
        // If question index = 11, user completed the quiz, and now index is 11. set submit button text to complete.
        if (currentQuestionIndex == 11) {
            submitBtn.setTitle("Finish", for: .normal)
        } else {
            if (data["Data \(currentQuestionIndex)"] == nil) {
                currentQuizQn = data["Data \(currentQuestionIndex)"]!
            } else {
                currentQuizQn = data["Data \(currentQuestionIndex)"]!
            }
            
            questionTextView.text = currentQuizQn[0] // Gets the Question at Array Path 0
            currentQuizQn.remove(at: 0) // Removes the Question from Array
            print(currentQuizQn)
            currentQuizAns = currentQuizQn[3] // Last index of Array is the correct answer
            
            for _ in 0...5 { // Shuffles the Answer Order
                currentQuizQn.shuffle()
            }
            
            // Set Button Lines
            optionOneBtn.titleLabel?.numberOfLines = 0;
            optionOneBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            optionTwoBtn.titleLabel?.numberOfLines = 0;
            optionTwoBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            optionThreeBtn.titleLabel?.numberOfLines = 0;
            optionThreeBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            optionFourBtn.titleLabel?.numberOfLines = 0;
            optionFourBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            
            // Sets the Options
            optionOneBtn.setTitle(currentQuizQn[0], for: .normal)
            optionTwoBtn.setTitle(currentQuizQn[1], for: .normal)
            optionThreeBtn.setTitle(currentQuizQn[2], for: .normal)
            optionFourBtn.setTitle(currentQuizQn[3], for: .normal)
            
            // Set the question number
            questionNumber.text = "Question \(currentQuestionIndex)/10"
            
            // Set the text of the submit button back to submit
            submitBtn.setTitle("Submit", for: .normal)
            
            resetButtonColours()
        }
    }
    
    func checkAnswer() {
        
        let originalColour = UIColor.systemGray
        let incorrectColour = UIColor.systemRed
        let correctColour = UIColor.systemGreen
        
        // Reset all button to original colour
        optionOneBtn.backgroundColor = originalColour
        optionTwoBtn.backgroundColor = originalColour
        optionThreeBtn.backgroundColor = originalColour
        optionFourBtn.backgroundColor = originalColour
        
        // Check which button has the correct answer
        if (optionOneBtn.currentTitle == currentQuizAns) {
            optionOneBtn.backgroundColor = correctColour
        } else if (optionTwoBtn.currentTitle == currentQuizAns) {
            optionTwoBtn.backgroundColor = correctColour
        } else if (optionThreeBtn.currentTitle == currentQuizAns) {
            optionThreeBtn.backgroundColor = correctColour
        } else if (optionFourBtn.currentTitle == currentQuizAns) {
            optionFourBtn.backgroundColor = correctColour
        }
        
        if (userPressedOption != currentQuizAns) { // User got the question wrong
            incorrectQuestions.append("Question \(currentQuestionIndex)")
            if (optionOneBtn.currentTitle == userPressedOption) {
                optionOneBtn.backgroundColor = incorrectColour
            } else if (optionTwoBtn.currentTitle == userPressedOption) {
                optionTwoBtn.backgroundColor = incorrectColour
            } else if (optionThreeBtn.currentTitle == userPressedOption) {
                optionThreeBtn.backgroundColor = incorrectColour
            } else if (optionFourBtn.currentTitle == userPressedOption) {
                optionFourBtn.backgroundColor = incorrectColour
            }
        } else {
            correctQuestions.append("Question \(currentQuestionIndex)")
        }
        
        // If question index = 11, user completed the quiz, and now index is 11. set submit button text to complete.
        if (currentQuestionIndex == 11) {
            submitBtn.setTitle("Finish", for: .normal)
        } else {
            // Once user has seen the correct answer, set the submit button to the next button
            submitBtn.setTitle("Next", for: .normal)
        }
    }
    
    @IBAction func optionOneBtn(_ sender: Any) {
        userPressedOption = optionOneBtn.currentTitle!
        print(userPressedOption)
        
        optionOneBtn.backgroundColor = buttonSelectColour
        optionTwoBtn.backgroundColor = UIColor.systemGray
        optionThreeBtn.backgroundColor = UIColor.systemGray
        optionFourBtn.backgroundColor = UIColor.systemGray
        
        userDidSelectOption = true
    }
    
    @IBAction func optionTwoBtn(_ sender: Any) {
        userPressedOption = optionTwoBtn.currentTitle!
        print(userPressedOption)
        
        optionTwoBtn.backgroundColor = buttonSelectColour
        optionOneBtn.backgroundColor = UIColor.systemGray
        optionThreeBtn.backgroundColor = UIColor.systemGray
        optionFourBtn.backgroundColor = UIColor.systemGray
        
        userDidSelectOption = true
    }
    
    @IBAction func optionThreeBtn(_ sender: Any) {
        userPressedOption = optionThreeBtn.currentTitle!
        print(userPressedOption)
        
        optionThreeBtn.backgroundColor = buttonSelectColour
        optionTwoBtn.backgroundColor = UIColor.systemGray
        optionOneBtn.backgroundColor = UIColor.systemGray
        optionFourBtn.backgroundColor = UIColor.systemGray
        
        userDidSelectOption = true
    }
    
    @IBAction func optionFourBtn(_ sender: Any) {
        userPressedOption = optionFourBtn.currentTitle!
        print(userPressedOption)
        
        optionFourBtn.backgroundColor = buttonSelectColour
        optionTwoBtn.backgroundColor = UIColor.systemGray
        optionThreeBtn.backgroundColor = UIColor.systemGray
        optionOneBtn.backgroundColor = UIColor.systemGray
        
        userDidSelectOption = true
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        if (submitBtn.currentTitle == "Submit") {
            if (userDidSelectOption) {
                checkAnswer()
                userDidSelectOption = false
            } else {
                let alert = UIAlertController(title: "Please select a option before submitting!", message: "You can't submit a blank answer script during an exam right?", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
        } else if (submitBtn.currentTitle == "Next") {
            currentQuestionIndex += 1
            quizConfig()
        } else if (submitBtn.currentTitle == "Finish") {
            userDefaults.set(correctQuestions, forKey: "Correct Questions")
            userDefaults.set(incorrectQuestions, forKey: "Incorrect Questions")
            
            performSegue(withIdentifier: "reviewScore", sender: nil)
        }
    }
}
