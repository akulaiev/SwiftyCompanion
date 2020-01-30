//
//  SkillsViewController.swift
//  SwiftyCompanion
//
//  Created by Anna KULAIEVA on 1/6/20.
//  Copyright © 2020 Anna Koulaeva. All rights reserved.
//

import UIKit
import Charts

class SkillsViewController: UIViewController {
    
    @IBOutlet weak var radarChartView: RadarChartView!
    
    var skills: [String : Double] = [:]
    let allSkillNames = ["Adaptation & creativity", "Algorithms & AI", "Company experience", "DB & Data", "Functional programming", "Graphics", "Group & interpersonal", "Imperative programming", "Network & system administration", "Object-oriented programming", "Organization", "Parallel computing", "Rigor", "Security", "Technology integration", "Unix", "Web"]
    var allSkills: [String : Double] = [:]
    var color: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if skills.count > 0 {
            for name in allSkillNames {
                if let level = skills[name] {
                    allSkills[name] = level
                }
                else {
                    allSkills[name] = 0.0
                }
                setChart(skills: allSkills)
            }
        }
        else {
            SharedHelperMethods.showFailureAlert(title: "No skills data", message: "There is no skills data available.", controller: self)
        }
    }
    
    func setChart(skills: [String : Double]) {
        var dataEntries: [RadarChartDataEntry] = []
        let sortedKeys = skills.keys.sorted()
        for key in sortedKeys {
            if let val = skills[key] {
                let dataEntry = RadarChartDataEntry(value: val, data: key)
                dataEntries.append(dataEntry)
            }
        }
        let chartDataSet = RadarChartDataSet(entries: dataEntries, label: "Skills")
        chartDataSet.colors = [SharedHelperMethods.hexStringToUIColor(hex: color)]
        chartDataSet.fillColor = SharedHelperMethods.hexStringToUIColor(hex: color)
        chartDataSet.drawFilledEnabled = true
        let chartData = RadarChartData(dataSet: chartDataSet)
        radarChartView.data = chartData
    }
}
