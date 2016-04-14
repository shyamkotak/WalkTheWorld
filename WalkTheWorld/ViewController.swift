//
//  ViewController.swift
//  WalkTheWorld
//
//  Created by Shyam Kotak on 4/12/16.
//  Copyright © 2016 JS. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    var steps : Int = 0
    var run : Int = 0
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.text = String(self.steps)
        
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable() {
                return HKHealthStore()
            } else {
                return nil
            }
        }()
        
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierStepCount)
        
        //let dataTypesToWrite = NSSet(object: stepsCount!)
        let dataTypesToRead = NSSet(object: stepsCount!)
        
        //        healthStore?.requestAuthorizationToShareTypes(dataTypesToWrite as? Set<HKSampleType>,
        //            readTypes: dataTypesToRead as? Set<HKObjectType>,
        //            completion: { [unowned self] (success, error) in
        //                if success {
        //                    print("SUCCESS")
        //                } else {
        //                    print(error!.description)
        //                }
        //            })
        
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
        
        let stepsSampleQuery = HKSampleQuery(sampleType: stepsCount!,
            predicate: nil,
            limit: 100,
            sortDescriptors: nil)
            { [unowned self] (query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    print("here")
                    for result in results as [HKQuantitySample] {
                        counter = counter + Int(result.quantity.doubleValueForUnit(HKUnit.countUnit()))
                        print(counter)
                    }
                    self.steps = counter
                    self.run = self.run + 1;
                    print("onemoretime")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.viewDidLoad()
                    })
                }
        }
        
        // Don't forget to execute the Query!
        if(run == 1) {
            healthStore?.executeQuery(stepsSampleQuery)
        }
        if (run == 2){
            self.label.text = String(self.steps)
            print("yo")
            print(self.steps)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}