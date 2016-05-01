//
//  ChartViewController.swift
//  WalkTheWorld
//
//  Created by Shyam Kotak on 4/19/16.
//  Copyright © 2016 JS. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    var days : [String] = []
    var stepsPerDay : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set title
        self.navigationItem.title = "Weekly Report"
        
        //get the last 7 days
        let calendar = NSCalendar.currentCalendar()
        let sevenDaysAgo = calendar.dateByAddingUnit(.Day, value: -7, toDate: NSDate(), options: [])
        let sixDaysAgo = calendar.dateByAddingUnit(.Day, value: -6, toDate: NSDate(), options: [])
        let fiveDaysAgo = calendar.dateByAddingUnit(.Day, value: -5, toDate: NSDate(), options: [])
        let fourDaysAgo = calendar.dateByAddingUnit(.Day, value: -4, toDate: NSDate(), options: [])
        let threeDaysAgo = calendar.dateByAddingUnit(.Day, value: -3, toDate: NSDate(), options: [])
        let twoDaysAgo = calendar.dateByAddingUnit(.Day, value: -2, toDate: NSDate(), options: [])
        let oneDaysAgo = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
        let today = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        days.append(dateFormatter.stringFromDate(sevenDaysAgo!))
        days.append(dateFormatter.stringFromDate(sixDaysAgo!))
        days.append(dateFormatter.stringFromDate(fiveDaysAgo!))
        days.append(dateFormatter.stringFromDate(fourDaysAgo!))
        days.append(dateFormatter.stringFromDate(threeDaysAgo!))
        days.append(dateFormatter.stringFromDate(twoDaysAgo!))
        days.append(dateFormatter.stringFromDate(oneDaysAgo!))
        days.append(dateFormatter.stringFromDate(today))
        
        setChart(days, values: stepsPerDay)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        //set data
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Steps Walked")
        chartDataSet.axisDependency = .Left;
        chartDataSet.valueTextColor = UIColor.whiteColor()
        let chartData = BarChartData(xVals: days, dataSet: chartDataSet)
        barChartView.data = chartData
        
        //set colors
        chartDataSet.colors = ChartColorTemplates.joyful()
        self.barChartView.gridBackgroundColor = UIColor.blackColor()
        
        //set animation
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        //set description
        barChartView.descriptionText = ""
        
        //set target
        let ll = ChartLimitLine(limit: 10000, label: "")
        barChartView.rightAxis.addLimitLine(ll)
        
        //change x axis
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.drawGridLinesEnabled = false;
        barChartView.xAxis.setLabelsToSkip(0)
        barChartView.xAxis.labelTextColor = UIColor.whiteColor()
        
        //change y axis
        barChartView.rightAxis.enabled = false;
        barChartView.leftAxis.enabled = false;
        
        //change label color
        barChartView.legend.textColor = UIColor.whiteColor()
        
        barChartView.scaleXEnabled = false;
        barChartView.scaleYEnabled = false;
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

}
