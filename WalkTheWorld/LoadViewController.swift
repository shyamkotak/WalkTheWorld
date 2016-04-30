//
//  LoadViewController.swift
//  WalkTheWorld
//
//  Created by Julia Pohlmann on 4/29/16.
//  Copyright © 2016 JS. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import Gifu

class LoadViewController: UIViewController {
    
    var run : Int = 0
    var currentSteps: Double = 0
    var stepsPerDay : [Double] = []

    @IBOutlet weak var animatedImage: AnimatableImageView!
    @IBOutlet weak var FunFact: UILabel!
    var facts: [String] = ["If you add just 2,000 more steps a day to your regular activities, you may never gain another pound.", "Walking around 20-25 miles each week can extend your life by a couple of years."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelFact()
        animatedImage.animateWithImage(named: "load_screen_globe_gif.gif")
        gatherHealthData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ToMainView" {
            print("here")
            print(self.currentSteps)
            print(self.stepsPerDay)
            let destinationVC = segue.destinationViewController as! ViewController
            destinationVC.currentSteps = self.currentSteps
            destinationVC.stepsPerDay = self.stepsPerDay
        }
    }
    
    func setLabelFact() {
        let index = Int(arc4random_uniform(UInt32(facts.count)) + 1)
        //print(index-1)
        FunFact.text = facts[index-1]
        FunFact.textColor = UIColor.whiteColor()
    }
    
    func gatherHealthData() {
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable() {
                return HKHealthStore()
            } else {
                return nil
            }
        }()
        
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierStepCount)
        
        let dataTypesToRead = NSSet(object: stepsCount!)
        
        if (run == 0) {
            healthStore?.requestAuthorizationToShareTypes(nil,
                readTypes: dataTypesToRead as? Set<HKObjectType>,
                completion: { [unowned self] (success, error) in
                    if success {
                        print("SUCCESS")
                        self.run++;
                        dispatch_async(dispatch_get_main_queue(), {
                            self.gatherHealthData()
                        })
                    } else {
                        print(error!.description)
                    }
                })
        }
        
        
        var counter : Int = 0;
        
        //this is to get the today at midnight so
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let todayAtMidnight = cal.startOfDayForDate(date)
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(todayAtMidnight, endDate: NSDate(), options: .None)
        
        let stepsSampleQuery = HKSampleQuery(sampleType: stepsCount!,
            predicate: predicate,
            limit: 100,
            sortDescriptors: nil)
            { [unowned self] (query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    for result in results as [HKQuantitySample] {
                        counter = counter + Int(result.quantity.doubleValueForUnit(HKUnit.countUnit()))
                        print(counter)
                    }
                    self.currentSteps = Double(counter);
                    self.run = self.run + 1;
                    dispatch_async(dispatch_get_main_queue(), {
                        self.gatherHealthData()
                    })
                }
        }
        
        //this is now for the second query.
        //we want steps taken for last 7 days
        let sevenDaysAgo = cal.dateByAddingUnit(.Day, value: -7, toDate: NSDate(), options: [])
        let sevenDaysAgoAtMidnight = cal.startOfDayForDate(sevenDaysAgo!)
        
        let interval = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!,
            quantitySamplePredicate: nil,
            options: .CumulativeSum,
            anchorDate: sevenDaysAgoAtMidnight,
            intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            
            let statsCollection = results
            
            let endDate = NSDate()
            let startDate = sevenDaysAgoAtMidnight
            
            // Plot the weekly step counts over the past 3 months
            statsCollection!.enumerateStatisticsFromDate(startDate, toDate: endDate) {statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let value = quantity.doubleValueForUnit(HKUnit.countUnit())
                    
                    print("I walked")
                    print(value)
                    self.stepsPerDay.append(value)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("ToMainView", sender: self)
            })
        }
        
        // Don't forget to execute the Query!
        if(run == 1) {
            healthStore?.executeQuery(stepsSampleQuery)
        }
        
        if(run == 2) {
            print("yo whats up")
            healthStore?.executeQuery(query)
        }

    }
    
    
}
