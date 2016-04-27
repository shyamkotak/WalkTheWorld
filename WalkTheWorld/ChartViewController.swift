//
//  ChartViewController.swift
//  WalkTheWorld
//
//  Created by Shyam Kotak on 4/27/16.
//  Copyright © 2016 JS. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    var days : [String] = ["7", "6", "5", "4", "3", "2", "1", "Today"]
    var stepsPerDay : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(stepsPerDay)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
