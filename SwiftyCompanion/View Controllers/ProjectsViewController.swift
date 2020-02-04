//
//  ProjectsViewController.swift
//  SwiftyCompanion
//
//  Created by Anna KULAIEVA on 1/30/20.
//  Copyright © 2020 Anna Koulaeva. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var projectsTableView: UITableView!
    var projectNames: [String] = []
    var projectStatus: [String] = []
    var projectsValidated: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = projectsTableView.dequeueReusableCell(withIdentifier: "projectCell")!
        cell.textLabel?.text = projectNames[indexPath.row]
        if projectStatus[indexPath.row] == "in_progress" {
            cell.detailTextLabel?.textColor = UIColor.yellow
            cell.detailTextLabel?.text = "In progress"
        }
        else {
            if (projectsValidated[indexPath.row]) {
                cell.detailTextLabel?.textColor = UIColor.green
                cell.detailTextLabel?.text = "Finished"
            }
            else {
                cell.detailTextLabel?.textColor = UIColor.red
                cell.detailTextLabel?.text = "Failed"
            }
        }
        return cell
    }

}
