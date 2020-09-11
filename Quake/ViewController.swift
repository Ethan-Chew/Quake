//
//  ViewController.swift
//  Quake
//
//  Created by Ethan Chew on 11/9/20.
//

import UIKit

class ViewController: UIViewController {

    // Variables
    let earthquake = Earthquake()
    let userDefaults = UserDefaults.standard
    let currentCountry = "Singapore"
        // Gradient Colours
        let lightBlue = UIColor(red: 76/255, green: 163/255, blue: 209/255, alpha: 1)
        let realBlue = UIColor(red: 0/255, green: 132/255, blue: 201/255, alpha: 1)
        let lightYellow = UIColor(red: 208/255, green: 216/255, blue: 105/255, alpha: 1)
        let realYellow = UIColor(red: 221/255, green: 206/255, blue: 0/255, alpha: 1)
        let lightRed = UIColor(red: 215/255, green: 140/255, blue: 129/255, alpha: 1)
        let realRed = UIColor(red: 225/255, green: 82/255, blue: 68/255, alpha: 1)
        // DEBUGGING USE ONLY
        let noEQOverride = false
        let minorEQOverride = false
        let majorEQOverride = false
    
    // No Earthquake UI Elements
    @IBOutlet weak var noEarthquake: UILabel!
    @IBOutlet weak var staySafeInfoLabel: UILabel!
    
    // Minor or Major Earthquake UI Elements
    @IBOutlet weak var earthquakeDetectedLabel: UILabel!
    @IBOutlet weak var staySafeLabel: UILabel!
        // Earthquake Info
        @IBOutlet weak var locationMessage: UILabel!
        @IBOutlet weak var magnitudeMessage: UILabel!
        @IBOutlet weak var lastUpdatedMessage: UILabel!
        @IBOutlet weak var locationLabel: UILabel!
        @IBOutlet weak var magnitudeLabel: UILabel!
        @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    
    // Buttons
    @IBOutlet weak var uselessBtn: UIButton!
    @IBOutlet weak var quizBtn: UIButton!
    
    // Labels
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    func checkEarthquakeStatus() {
        locLabel.text = currentCountry
        
        userDefaults.set(currentCountry, forKey: "User Country")
        
        if (earthquake.magnitude > 0.0 && earthquake.magnitude <= 3.0) { // Minor Earthquake
            
            locationLabel.isHidden = false
            magnitudeLabel.isHidden = false
            lastUpdatedLabel.isHidden = false
            locationMessage.isHidden = false
            magnitudeMessage.isHidden = false
            lastUpdatedMessage.isHidden = false
            earthquakeDetectedLabel.isHidden = false
            staySafeLabel.isHidden = false
            
            staySafeInfoLabel.isHidden = true
            noEarthquake.isHidden = true
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.view.bounds
            gradientLayer.colors = [realBlue.cgColor, lightBlue.cgColor]
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        } else if (earthquake.magnitude > 3.0 && earthquake.magnitude <= 5.0) { // Major Earthquake
            
            locationLabel.isHidden = false
            magnitudeLabel.isHidden = false
            lastUpdatedLabel.isHidden = false
            locationMessage.isHidden = false
            magnitudeMessage.isHidden = false
            lastUpdatedMessage.isHidden = false
            earthquakeDetectedLabel.isHidden = false
            staySafeLabel.isHidden = false
            
            staySafeInfoLabel.isHidden = true
            noEarthquake.isHidden = true
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.view.bounds
            gradientLayer.colors = [realRed.cgColor, lightRed.cgColor]
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        } else { // No Earthquake
            if (minorEQOverride) {
                
                locationLabel.isHidden = false
                magnitudeLabel.isHidden = false
                lastUpdatedLabel.isHidden = false
                locationMessage.isHidden = false
                magnitudeMessage.isHidden = false
                lastUpdatedMessage.isHidden = false
                earthquakeDetectedLabel.isHidden = false
                staySafeLabel.isHidden = false
                
                staySafeInfoLabel.isHidden = true
                noEarthquake.isHidden = true
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.view.bounds
                gradientLayer.colors = [realYellow.cgColor, lightYellow.cgColor]
            } else if (majorEQOverride) {
                
                locationLabel.isHidden = false
                magnitudeLabel.isHidden = false
                lastUpdatedLabel.isHidden = false
                locationMessage.isHidden = false
                magnitudeMessage.isHidden = false
                lastUpdatedMessage.isHidden = false
                earthquakeDetectedLabel.isHidden = false
                staySafeLabel.isHidden = false
                
                staySafeInfoLabel.isHidden = true
                noEarthquake.isHidden = true
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.view.bounds
                gradientLayer.colors = [realRed.cgColor, lightRed.cgColor]
                self.view.layer.insertSublayer(gradientLayer, at: 0)
            } else if (noEQOverride) {
                
                locationLabel.isHidden = true
                magnitudeLabel.isHidden = true
                lastUpdatedLabel.isHidden = true
                locationMessage.isHidden = true
                magnitudeMessage.isHidden = true
                lastUpdatedMessage.isHidden = true
                earthquakeDetectedLabel.isHidden = true
                staySafeLabel.isHidden = true
                
                staySafeInfoLabel.isHidden = false
                noEarthquake.isHidden = false
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.view.bounds
                gradientLayer.colors = [realBlue.cgColor, lightBlue.cgColor]
                self.view.layer.insertSublayer(gradientLayer, at: 0)
            } else {
                
                locationLabel.isHidden = true
                magnitudeLabel.isHidden = true
                lastUpdatedLabel.isHidden = true
                locationMessage.isHidden = true
                magnitudeMessage.isHidden = true
                lastUpdatedMessage.isHidden = true
                earthquakeDetectedLabel.isHidden = true
                staySafeLabel.isHidden = true
                
                staySafeInfoLabel.isHidden = false
                noEarthquake.isHidden = false
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.view.bounds
                gradientLayer.colors = [realBlue.cgColor, lightBlue.cgColor]
                self.view.layer.insertSublayer(gradientLayer, at: 0)
            }
        }
    }
    
    func applyRoundCorners(_ object: AnyObject) {
        object.layer?.cornerRadius = (object.frame?.size.width)! / 2
        object.layer.masksToBounds = true
    }
    
    func configureEarthquake() {
        
        let currentDate = Date()
        
        self.locationLabel.text = earthquake.location
        self.currentDateLabel.text = self.dateFormatter.string(from: earthquake.date ?? currentDate)
        self.lastUpdatedLabel.text =  self.dateFormatter.string(from: earthquake.date ?? currentDate)
        self.magnitudeLabel.text = String(format: "%.1f", Double(earthquake.magnitude))
    }
    
    // On-demand initializer for read-only property.
    private lazy var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyRoundCorners(uselessBtn)
        
        checkEarthquakeStatus()
        configureEarthquake()
    }


}

