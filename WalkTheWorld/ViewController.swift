//
//  ViewController.swift
//  WalkTheWorld
//
//  Created by Shyam Kotak on 4/12/16.
//  Copyright © 2016 JS. All rights reserved.
//

import UIKit
import HealthKit
import AVKit
import AVFoundation
import Charts
import CoreData

class ViewController: UIViewController {
    
    var run : Int = 0
    private let incompleteColor : UIColor = UIColor(red: 178/255, green: 52/255, blue: 32/255, alpha: 1)
    private let completeColor : UIColor = UIColor(red: 32/255, green: 178/255, blue: 112/255, alpha: 1)
    private let greyBarColor : UIColor = UIColor(red: 209/225, green: 209/255, blue: 209/225, alpha: 1)

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var buttonImage1: UIButton!
    @IBOutlet weak var buttonImage2: UIButton!
    @IBOutlet weak var buttonImage3: UIButton!
    @IBOutlet weak var buttonImage4: UIButton!
    @IBOutlet weak var buttonImage5: UIButton!
    
    @IBOutlet weak var stepProgress1: StepProgress!
    @IBOutlet weak var stepProgress2: StepProgress!
    @IBOutlet weak var stepProgress3: StepProgress!
    @IBOutlet weak var stepProgress4: StepProgress!
    @IBOutlet weak var stepProgress5: StepProgress!

    var currentSteps: Double = 0
    var totalSteps : [Double] = [10000, 8000, 6000, 4000, 2000]
    var stepPercents : [Double] = [0, 0, 0, 0, 0]
    var places : [String] = ["Mountains_Water", "NYC", "MultipleLandscapes", "GoldenGateBridge", "CNTower"]
    var stepsPerDay : [Double] = []
    var stepGoal : Int = 10000
    
    override func viewDidAppear(animated: Bool) {
        let originalGoal = stepGoal
        findStepGoal()
        if originalGoal != stepGoal {
            setProgressCircleGoals()
            //grey out all videos
            buttonImage1.enabled = false
            buttonImage2.enabled = false
            buttonImage3.enabled = false
            buttonImage4.enabled = false
            buttonImage5.enabled = false
        
            //make those cool bars
            setStepTotals()
            for index in 0 ... (totalSteps.count - 1) {
                var stepPercent = currentSteps / totalSteps[index]
                if stepPercent > 1.0 {
                    stepPercent = 1.0
                    enableButton(index+1)
                }
                stepPercents[index] = stepPercent
            }
            animateProgressCircles()
        
            //show the users the # of steps they've taken
            self.label.text = "Today's Steps: " + String(Int(self.currentSteps))
            if Int(self.currentSteps) >= stepGoal {
                self.label.textColor = completeColor
            } else {
                self.label.textColor = incompleteColor
            }
        }
    }
    
    func setProgressCircleGoals() {
        totalSteps[0] = Double(stepGoal)
        totalSteps[1] = totalSteps[0] - Double(stepGoal/5)
        totalSteps[2] = totalSteps[1] - Double(stepGoal/5)
        totalSteps[3] = totalSteps[2] - Double(stepGoal/5)
        totalSteps[4] = totalSteps[3] - Double(stepGoal/5)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set title
        self.navigationItem.title = "Walk The World"

        //remove back button
        self.navigationItem.hidesBackButton = true
        
        //set charts button
        let chartsBtn: UIButton = UIButton()
        chartsBtn.setImage(UIImage(named: "bar-chart-7-xxl.png"), forState: .Normal)
        chartsBtn.frame = CGRectMake(0, 0, 25, 25)
        chartsBtn.addTarget(self, action: "segueToChart:", forControlEvents: .TouchUpInside)

        //place button in top right
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: chartsBtn), animated: true)

        
        //set settings button
        let settingsBtn: UIButton = UIButton()
        settingsBtn.setImage(UIImage(named: "Button_Settings"), forState: .Normal)
        settingsBtn.frame = CGRectMake(0, 0, 25, 25)
        settingsBtn.addTarget(self, action: "segueToSettings:", forControlEvents: .TouchUpInside)
        
        //place button in top right
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: settingsBtn), animated: true)
        findStepGoal()
        setProgressCircleGoals()
        
        //grey out all videos
        buttonImage1.enabled = false
        buttonImage2.enabled = false
        buttonImage3.enabled = false
        buttonImage4.enabled = false
        buttonImage5.enabled = false
        
        //make those cool bars
        setStepTotals()
        for index in 0 ... (totalSteps.count - 1) {
            var stepPercent = currentSteps / totalSteps[index]
            if stepPercent > 1.0 {
                stepPercent = 1.0
                enableButton(index+1)
            }
            stepPercents[index] = stepPercent
        }
        animateProgressCircles()
        
        //show the users the # of steps they've taken
        self.label.text = "Today's Steps: " + String(Int(self.currentSteps))
        if Int(self.currentSteps) >= stepGoal {
            self.label.textColor = completeColor
        } else {
            self.label.textColor = incompleteColor
        }
    }
    
    func findStepGoal() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let employeesFetch = NSFetchRequest(entityName: "StepGoal")

        do {
            let fetchedStepGoals = try managedContext.executeFetchRequest(employeesFetch) as! [NSManagedObject]
            if fetchedStepGoals.count > 0 {
                stepGoal = (fetchedStepGoals[0].valueForKey("numSteps") as? Int)!
            } else {
                stepGoal = 10000
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    
    func setStepTotals() {
        stepProgress1.setTotalSteps(totalSteps[0])
        stepProgress2.setTotalSteps(totalSteps[1])
        stepProgress3.setTotalSteps(totalSteps[2])
        stepProgress4.setTotalSteps(totalSteps[3])
        stepProgress5.setTotalSteps(totalSteps[4])
    }
    
    func animateProgressCircles() {
        stepProgress1.animateProgressView(stepPercents[0])
        stepProgress2.animateProgressView(stepPercents[1])
        stepProgress3.animateProgressView(stepPercents[2])
        stepProgress4.animateProgressView(stepPercents[3])
        stepProgress5.animateProgressView(stepPercents[4])
    }
    
    func enableButton(buttonNum : Int) {
        switch buttonNum {
        case 1:
            buttonImage1.enabled = true
        case 2:
            buttonImage2.enabled = true
        case 3:
            buttonImage3.enabled = true
        case 4:
            buttonImage4.enabled = true
        case 5:
            buttonImage5.enabled = true
        default:
            print("ERROR: number not valid")
        }
    }
    
    //load correct movie
    @IBAction func didClickButton1(sender: AnyObject) {
        do {
            try playVideo(places[0])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    //load correct movie
    @IBAction func didClickButton2(sender: AnyObject) {
        do {
            try playVideo(places[1])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    //load correct movie
    @IBAction func didClickButton3(sender: AnyObject) {
        do {
            try playVideo(places[2])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    //load correct movie
    @IBAction func didClickButton4(sender: AnyObject) {
        do {
            try playVideo(places[3])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    //load correct movie
    @IBAction func didClickButton5(sender: AnyObject) {
        do {
            try playVideo(places[4])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    //to play the movie
    private func playVideo(name : String) throws {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType:"mp4") else {
            throw AppError.InvalidResource(name, "mp4")
        }
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
    
    enum AppError : ErrorType {
        case InvalidResource(String, String)
    }
    
    //when we go to the Chart
    func segueToChart(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toChart", sender: sender)
    }
    
    func segueToSettings(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toSettings", sender: sender)
    }
    
    //we need to pass the array of steps every day
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "toSettings" {
            let destinationVC = segue.destinationViewController as! SettingsViewController
            destinationVC.currentStepGoal = self.stepGoal
            destinationVC.stepsPerDay = self.stepsPerDay
        } else {
            let destinationVC = segue.destinationViewController as! ChartViewController
            destinationVC.stepsPerDay = self.stepsPerDay
            destinationVC.stepGoal = self.stepGoal
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
}