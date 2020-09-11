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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        quizConfig()
    }
    
    // Functions
    func getData() {
        
        // Collect Data
        var worksheetName = "Question Data"
        
        do {
            let filepath = Bundle.main.path(forResource: "Main Data", ofType: "xlsx")!
            
            guard let file = XLSXFile(filepath: filepath) else {
                fatalError("XLSX file at \(filepath) is corrupted or does not exist")
            }
            
            for wbk in try file.parseWorkbooks() {
                guard let path = try file.parseWorksheetPathsAndNames(workbook: wbk)
                        .first(where: { $0.name == worksheetName }).map({ $0.path })
                else { continue }
                
                let sharedStrings = try file.parseSharedStrings()
                let worksheet = try file.parseWorksheet(at: path)
                
                for i in 1...20 {
                    var parseData = worksheet.cells(atRows: [UInt(i)])
                        .compactMap { $0.stringValue(sharedStrings) }
                    
                    data["Data \(i)"] = parseData
                }
                
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func quizConfig() {
        var currentQuizQn: [String] = []
        
        if (data["Data \(currentQuestionIndex)"] == nil) {
            currentQuizQn = data["Data \(currentQuestionIndex)"]!
        } else {
            currentQuizQn = data["Data \(currentQuestionIndex)"]!
        }
        
        questionTextView.text = currentQuizQn[0] // Gets the Question at Array Path 0
        currentQuizQn.remove(at: 0) // Removes the Question from Array
        currentQuizAns = currentQuizQn[4] // Last index of Array is the correct answer
        
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
    }
    
    func checkAnswer() {
        
        let originalColour = UIColor.systemGray
        let incorrectColour = UIColor.red
        let correctColour = UIColor.green
        
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
            if (optionOneBtn.currentTitle == userPressedOption) {
                optionOneBtn.backgroundColor = incorrectColour
            } else if (optionTwoBtn.currentTitle == userPressedOption) {
                optionTwoBtn.backgroundColor = incorrectColour
            } else if (optionThreeBtn.currentTitle == userPressedOption) {
                optionThreeBtn.backgroundColor = incorrectColour
            } else if (optionFourBtn.currentTitle == userPressedOption) {
                optionFourBtn.backgroundColor = incorrectColour
            }
        }
        
        // If question index = 10, user completed the quiz. set submit button text to complete.
        if (currentQuestionIndex == 10) {
            submitBtn.setTitle("Finish", for: .normal)
        }
        
        // Once user has seen the correct answer, set the submit button to the next button
        submitBtn.setTitle("Next", for: .normal)
    }
    
    @IBAction func optionOneBtn(_ sender: Any) {
        userPressedOption = optionOneBtn.currentTitle!
        
        optionOneBtn.backgroundColor = buttonSelectColour
    }
    
    @IBAction func optionTwoBtn(_ sender: Any) {
        userPressedOption = optionTwoBtn.currentTitle!
        
        optionTwoBtn.backgroundColor = buttonSelectColour
    }
    
    @IBAction func optionThreeBtn(_ sender: Any) {
        userPressedOption = optionThreeBtn.currentTitle!
        
        optionThreeBtn.backgroundColor = buttonSelectColour
    }
    
    @IBAction func optionFourBtn(_ sender: Any) {
        userPressedOption = optionFourBtn.currentTitle!
        
        optionFourBtn.backgroundColor = buttonSelectColour
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        if (submitBtn.currentTitle == "Submit") {
            checkAnswer()
        } else if (submitBtn.currentTitle == "Next") {
            quizConfig()
        } else if (submitBtn.currentTitle == "Finish") {
            
        }
    }
}
