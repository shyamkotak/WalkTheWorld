//
//  SettingsViewController.swift
//  WalkTheWorld
//
//  Created by Julia Pohlmann on 4/30/16.
//  Copyright © 2016 JS. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    var currentStepGoal : Int = 0
    @IBOutlet weak var inputSteps: UITextField!
    @IBOutlet var currentLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    var stepsPerDay : [Double] = []
    
    @IBOutlet var suggestedSteps: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestGoal()
        currentLabel.textColor = UIColor.whiteColor()
        promptLabel.textColor = UIColor.whiteColor()
        currentLabel.text = "Current step goal: \(currentStepGoal)"
        inputSteps.keyboardType = UIKeyboardType.NumberPad

    }
    
    @IBAction func buttonClick(sender: AnyObject) {
        saveStepGoal(Int(inputSteps.text!)!)
        currentLabel.text = "Current step goal: \(currentStepGoal)"
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func saveStepGoal(goal: Int) {
        if goal > 0 {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let employeesFetch = NSFetchRequest(entityName: "StepGoal")
        
            do {
                let fetchedStepGoals = try managedContext.executeFetchRequest(employeesFetch) as! [NSManagedObject]
                if fetchedStepGoals.count > 0 {
                    let managedObject = fetchedStepGoals[0]
                    managedObject.setValue(goal, forKey: "numSteps")
                    try managedContext.save()
                    currentStepGoal = goal
                }
                else {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext
                    let entity =  NSEntityDescription.entityForName("StepGoal", inManagedObjectContext:managedContext)
                    let stepGoal = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                    stepGoal.setValue(goal, forKey: "numSteps")
                }
                currentStepGoal = goal
                
            } catch {
                fatalError("Failed to save step goal: \(error)")
            }
        }
    }
    
    func suggestGoal () {
        var goal = 10000
        if stepsPerDay.count > 0 {
            goal = findAverage()
            let max = findMax()
            goal = max - (max - goal)/2
        }
        suggestedSteps.text = "Suggested goal: \(String(goal))"
    }
    
    func findAverage() -> Int {
        var total = 0
        for i in 0..<stepsPerDay.count-1 {
            total = total + Int(stepsPerDay[i])
        }
        
        return total/(stepsPerDay.count-1)
    }
    
    func findMax() -> Int {
        var max = 0
        for i in 0..<stepsPerDay.count-1 {
            if Int(stepsPerDay[i]) > max {
                max = Int(stepsPerDay[i])
            }
        }
        
        return max
    }
    
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        let destinationVC = segue.destinationViewController as! ViewController
//        destinationVC.findStepGoal()
//        destinationVC.setProgressCircleGoals()
//        
//        //grey out all videos
//        destinationVC.buttonImage1.enabled = false
//        destinationVC.buttonImage2.enabled = false
//        destinationVC.buttonImage3.enabled = false
//        destinationVC.buttonImage4.enabled = false
//        destinationVC.buttonImage5.enabled = false
//        
//        //make those cool bars
//        destinationVC.setStepTotals()
//
//    }
    
    
    
    
}

