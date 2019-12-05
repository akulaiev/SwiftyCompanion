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
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var correctionPointsLabel: UILabel!
    @IBOutlet weak var coalitionLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var campusCityLabel: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var userData: UserResponse!
    var userId: String = ""
    
    fileprivate func setImages(url: URL, imageView: UIImageView, indicator: UIActivityIndicatorView?) {
        NetworkingTasks.downloadImage(url: url) { (image, error) in
            guard let image = image else {
                SharedHelperMethods.showFailureAlert(title: "An error has occured", message: error!.localizedDescription, controller: self)
                return
            }
            if let indicator = indicator {
                indicator.stopAnimating()
            }
            imageView.image = image
        }
    }
    
    func setInfoLabels(_ userData: UserResponse) {
        walletLabel.text = String(userData.wallet)
        correctionPointsLabel.text = String(userData.correctionPoint)
        usernameLabel.text = userData.displayname + " (" + userData.login + ")"
        levelLabel.text = String(userData.cursusUsers[0].level)
        levelBar.progress = Float(userData.cursusUsers[0].level - Double(Int(userData.cursusUsers[0].level)))
        if let grade = userData.cursusUsers[0].grade {
            rankLabel.text = grade
        }
        campusCityLabel.text = userData.campus[0].country + ", " + userData.campus[0].city
        FortyTwoAPIClient.getCoalitionsInfo(userID: String(userData.id)) { (response, error) in
            guard let response = response else {
                SharedHelperMethods.showFailureAlert(title: "An error has occured", message: error!.localizedDescription, controller: self)
                return
            }
            self.coalitionLabel.text = response[0].name
            self.levelBar.progressTintColor = SharedHelperMethods.hexStringToUIColor(hex: response[0].color)
            self.logoutButton.tintColor = self.levelBar.progressTintColor
            self.setImages(url: URL(string: response[0].coverURL)!, imageView: self.backgroundImageView, indicator: nil)
        }
        
    }
    
    fileprivate func getUserData() {
        activityIndicator.startAnimating()
        FortyTwoAPIClient.getUserInfo(userId: userId) {(response, error) in
            guard let response = response else {
                SharedHelperMethods.showFailureAlert(title: "An error has occured", message: error!.localizedDescription, controller: self)
                return
            }
            self.userData = response
            self.setImages(url: URL(string: response.imageURL)!, imageView: self.userImageView, indicator: self.activityIndicator)
            self.setInfoLabels(response)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }

    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        FortyTwoAPIClient.AuthenticationInfo.token = ""
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "expieryDate")
        
        self.dismiss(animated: true, completion: nil)
    }
}
