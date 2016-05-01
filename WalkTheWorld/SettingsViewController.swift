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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if goal > 1000 {
            print("GOAL IS \(goal)")
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

