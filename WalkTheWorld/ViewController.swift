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

class ViewController: UIViewController {
    
    var run : Int = 0
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove back button
        self.navigationItem.hidesBackButton = true
        
        //grey out all videos
        buttonImage1.enabled = false
        buttonImage2.enabled = false
        buttonImage3.enabled = false
        buttonImage4.enabled = false
        buttonImage5.enabled = false
        
        //place button in top right
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "RightButton", style: UIBarButtonItemStyle.Plain, target: self, action: "segueToChart:")
        self.navigationItem.rightBarButtonItem = logButton
        
//        let healthStore: HKHealthStore? = {
//            if HKHealthStore.isHealthDataAvailable() {
//                return HKHealthStore()
//            } else {
//                return nil
//            }
//        }()
//        
//        let stepsCount = HKQuantityType.quantityTypeForIdentifier(
//            HKQuantityTypeIdentifierStepCount)
//        
//        let dataTypesToRead = NSSet(object: stepsCount!)
//        
//        if (run == 0) {
//            healthStore?.requestAuthorizationToShareTypes(nil,
//                readTypes: dataTypesToRead as? Set<HKObjectType>,
//                completion: { [unowned self] (success, error) in
//                    if success {
//                        print("SUCCESS")
//                        self.run++;
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.viewDidLoad()
//                        })
//                    } else {
//                        print(error!.description)
//                    }
//                })
//        }
//        
//        
//        var counter : Int = 0;
//        
//        //this is to get the today at midnight so
//        let date = NSDate()
//        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
//        let todayAtMidnight = cal.startOfDayForDate(date)
//        
//        let predicate = HKQuery.predicateForSamplesWithStartDate(todayAtMidnight, endDate: NSDate(), options: .None)
//        
//        let stepsSampleQuery = HKSampleQuery(sampleType: stepsCount!,
//            predicate: predicate,
//            limit: 100,
//            sortDescriptors: nil)
//            { [unowned self] (query, results, error) in
//                if let results = results as? [HKQuantitySample] {
//                    for result in results as [HKQuantitySample] {
//                        counter = counter + Int(result.quantity.doubleValueForUnit(HKUnit.countUnit()))
//                        print(counter)
//                    }
//                    self.currentSteps = Double(counter);
//                    self.run = self.run + 1;
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.viewDidLoad()
//                    })
//                }
//        }
//        
//        //this is now for the second query.
//        //we want steps taken for last 7 days
//        let sevenDaysAgo = cal.dateByAddingUnit(.Day, value: -7, toDate: NSDate(), options: [])
//        let sevenDaysAgoAtMidnight = cal.startOfDayForDate(sevenDaysAgo!)
//        
//        let interval = NSDateComponents()
//        interval.day = 1
//        
//        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!,
//            quantitySamplePredicate: nil,
//            options: .CumulativeSum,
//            anchorDate: sevenDaysAgoAtMidnight,
//            intervalComponents: interval)
//        
//        query.initialResultsHandler = {
//            query, results, error in
//            
//            let statsCollection = results
//            
//            let endDate = NSDate()
//            let startDate = sevenDaysAgoAtMidnight
//            
//            // Plot the weekly step counts over the past 3 months
//            statsCollection!.enumerateStatisticsFromDate(startDate, toDate: endDate) {statistics, stop in
//                
//                if let quantity = statistics.sumQuantity() {
//                    //let date = statistics.startDate
//                    let value = quantity.doubleValueForUnit(HKUnit.countUnit())
//                    
//                    // Call a custom method to plot each data point.
//                    //self.plotWeeklyStepCount(value, forDate: date)
//                    print("I walked")
//                    print(value)
//                    self.stepsPerDay.append(value)
//                }
//            }
//        }
//        
//        
//        // Don't forget to execute the Query!
//        if(run == 1) {
//            healthStore?.executeQuery(query)
//            healthStore?.executeQuery(stepsSampleQuery)
//        }
//        if (run == 2){
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
            self.label.text = String(self.currentSteps)
//        }
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
    
    @IBAction func didClickButton1(sender: AnyObject) {
        do {
            try playVideo(places[0])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    @IBAction func didClickButton2(sender: AnyObject) {
        do {
            try playVideo(places[1])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    @IBAction func didClickButton3(sender: AnyObject) {
        do {
            try playVideo(places[2])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    @IBAction func didClickButton4(sender: AnyObject) {
        do {
            try playVideo(places[3])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    @IBAction func didClickButton5(sender: AnyObject) {
        do {
            try playVideo(places[4])
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
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
    
    func segueToChart(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toChart", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as! ChartViewController
        destinationVC.stepsPerDay = self.stepsPerDay
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}