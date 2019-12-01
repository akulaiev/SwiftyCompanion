//
//  UserInfoViewController.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 28.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var otherDataTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var levelBar: UIProgressView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherDataTableView.delegate = self
        otherDataTableView.dataSource = self
        FortyTwoAPIClient.getMyInfo { (response, error) in
            guard let response = response else {
                SharedHelperMethods.showFailureAlert(title: "An error has occured", message: error!.localizedDescription, controller: self)
                return
            }
            print(response)
        }
    }

    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        FortyTwoAPIClient.AuthenticationInfo.token = ""
        UserDefaults.standard.removeObject(forKey: "accessToken")
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! CustomTableViewCell
        return cell
    }
}
