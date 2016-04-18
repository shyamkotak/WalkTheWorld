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

    var totalSteps : [Double] = [10000, 8000, 6000, 4000, 2000]
    var places : [String] = ["Mountains_Water", "NYC", "MultipleLandscapes", "GoldenGateBridge", "CNTower"]
    var currentSteps: Double = 0
    var stepPercents : [Double] = [0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //buttonImage1.enabled = false
        //buttonImage2.enabled = false
        //buttonImage3.enabled = false
        //buttonImage4.enabled = false
        //buttonImage5.enabled = false
        
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
                            self.viewDidLoad()
                        })
                    } else {
                        print(error!.description)
                    }
                })
        }
        
        
        var counter : Int = 0;
        
        let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(
            .Hour,
            value: -24,
            toDate: NSDate(),
            options: [])
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(yesterday, endDate: NSDate(), options: .None)
        
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
                        print("HERE2")
                        self.viewDidLoad()
                    })
                }
        }
        
        // Don't forget to execute the Query!
        if(run == 1) {
            healthStore?.executeQuery(stepsSampleQuery)
        }
        if (run == 2){
            setStepTotals()
            
            print("button image size  is \(buttonImage1.frame.size)")
            print("progress view size is \(stepProgress1.frame.size)")
            //view.backgroundColor = UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}