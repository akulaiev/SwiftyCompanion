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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var levelBar: UIProgressView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var otherInfoTableView: UITableView!
    
    var userData: MeResponse!
    
    fileprivate func getUserData() {
        activityIndicator.startAnimating()
        FortyTwoAPIClient.getMyInfo { (response, error) in
            guard let response = response else {
                SharedHelperMethods.showFailureAlert(title: "An error has occured", message: error!.localizedDescription, controller: self)
                return
            }
            self.userData = response
            if let userData = self.userData {
                let task = URLSession.shared.dataTask(with: URL(string: userData.imageURL)!) { (data, response, error) in
                    guard let data = data else {
                        print(error!.localizedDescription)
                        return
                    }
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.userImageView.image = UIImage(data: data)
                        self.usernameLabel.text = userData.displayname + " (" + userData.login + ")"
                        self.levelLabel.text = String(userData.cursusUsers[0].level)
                        self.levelBar.progress = Float(userData.cursusUsers[0].level - Double(Int(userData.cursusUsers[0].level)))
                    }
                }
                task.resume()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        otherInfoTableView.delegate = self
        otherInfoTableView.dataSource = self
    }

    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        FortyTwoAPIClient.AuthenticationInfo.token = ""
        UserDefaults.standard.removeObject(forKey: "accessToken")
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
