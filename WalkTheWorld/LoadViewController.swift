//
//  LoadViewController.swift
//  WalkTheWorld
//
//  Created by Julia Pohlmann on 4/17/16.
//  Copyright © 2016 JS. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import Gifu

class LoadViewController: UIViewController {
    
    //this is # of times we have called gather health data
    //0 = make sure that we have permission
    //1 = run the first query
    //2 = run the second query and then move to main screen
    var run : Int = 0
    //this is to store the results of the first query
    var currentSteps: Double = 0
    //this is to store the results of the second query
    var stepsPerDay : [Double] = []

    //how we animate an image
    @IBOutlet weak var animatedImage: AnimatableImageView!
    //we put a fun fact underneath the image
    @IBOutlet weak var FunFact: UILabel!
    //these are some sample facts
    var facts: [String] = ["If you add just 2,000 more steps a day to your regular activities, you may never gain another pound.", "Walking around 20-25 miles each week can extend your life by a couple of years.", "A 20-minute walk, or about 2,000 steps, equal a mile", "The most popular form of exercise in the United States is walking", "A typical pair of tennis shoes will last 500 miles of walking.", "The United States walks the least of any industrialized nation."]
    
    private let greyBarColor : UIColor = UIColor(red: 209/225, green: 209/255, blue: 209/225, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //first set the fact
        setLabelFact()
        //then load the GIF
        animatedImage.animateWithImage(named: "load_screen_globe_gif.gif")
        //and now run the queries
        gatherHealthData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ToMainView" {
            let destinationVC = segue.destinationViewController as! ViewController
            destinationVC.currentSteps = self.currentSteps
            destinationVC.stepsPerDay = self.stepsPerDay
        }
    }
    
    func setLabelFact() {
        //pick a random fact!
        let index = Int(arc4random_uniform(UInt32(facts.count)) + 1)
        //print(index-1)
        FunFact.text = facts[index-1]
        FunFact.textColor = UIColor.whiteColor()
    }
    
    func gatherHealthData() {
        //get the health kit store
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable() {
                return HKHealthStore()
            } else {
                return nil
            }
        }()
        
        //we want to be able to see steps count
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierStepCount)
        
        //and only read it
        let dataTypesToRead = NSSet(object: stepsCount!)
        
        //now request autorization
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
        
        //this will store each walking instance and add it all up in the query
        var counter : Int = 0;
        
        //this is to get the date today at midnight so we can get all steps after that
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let todayAtMidnight = cal.startOfDayForDate(date)
        
        //all steps from todayatmidnight to now
        let predicate = HKQuery.predicateForSamplesWithStartDate(todayAtMidnight, endDate: NSDate(), options: .None)
        
        //and here is the first query
        let stepsSampleQuery = HKSampleQuery(sampleType: stepsCount!,
            predicate: predicate,
            limit: 100,
            sortDescriptors: nil)
            { [unowned self] (query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    for result in results as [HKQuantitySample] {
                        //add up all results
                        counter = counter + Int(result.quantity.doubleValueForUnit(HKUnit.countUnit()))
                    }
                    //and set it to current steps
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
        
        //interval is every day
        let interval = NSDateComponents()
        interval.day = 1
        
        //here is the query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!,
            quantitySamplePredicate: nil,
            options: .CumulativeSum,
            anchorDate: sevenDaysAgoAtMidnight,
            intervalComponents: interval)
        
        //and heres how we handle the results
        //notice this is a statisticsCollectionQuery
        query.initialResultsHandler = {
            query, results, error in
            
            let statsCollection = results
            
            let endDate = NSDate()
            let startDate = sevenDaysAgoAtMidnight
            
            // Plot the weekly step counts over the past 3 months
            statsCollection!.enumerateStatisticsFromDate(startDate, toDate: endDate) {statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    //steps for full day
                    let value = quantity.doubleValueForUnit(HKUnit.countUnit())
                    self.stepsPerDay.append(value)
                }
            }
            //and when we're done with the second query, we can go to the mainview
            dispatch_async(dispatch_get_main_queue(), {
               self.performSegueWithIdentifier("ToMainView", sender: self)
            })
        }
        
        // Don't forget to execute the Query!
        if(run == 1) {
            healthStore?.executeQuery(stepsSampleQuery)
        }
        
        //and the second one
        if(run == 2) {
            healthStore?.executeQuery(query)
        }

    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
}
