//
//  UserInfoViewController.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 28.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import UIKit
import CoreData

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
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followedUsersButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIButton!
    
    var userData: UserResponse!
    var userId: String = ""
    var dataController: DataController = AppDelegate.dataController
    var followUserData: FollowedUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userId.isEmpty {
            followButton.isHidden = true
        }
        else {
            followUserData = checkFollowedUser()
            if followUserData != nil {
                followButton.setImage(UIImage(named: "unfollow"), for: UIControl.State.normal)
            }
        }
        getUserData()
    }
    
    func checkFollowedUser() -> FollowedUser? {
        let predicate = NSPredicate(format: "userId == %@", userId)
        let result = dataController.fetchRecordsForEntity("FollowedUser", inManagedObjectContext: dataController.viewContext, predicate: predicate)
        if result.count == 0 {
            return nil
        }
        return (result[0] as! FollowedUser)
    }
    
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
        if userData.cursusUsers.count > 0 {
            levelLabel.text = String(userData.cursusUsers[0].level)
            levelBar.progress = Float(userData.cursusUsers[0].level - Double(Int(userData.cursusUsers[0].level)))
        }
        if let grade = userData.cursusUsers[0].grade {
            rankLabel.text = grade
        }
        campusCityLabel.text = userData.campus[0].country + ", " + userData.campus[0].city
        FortyTwoAPIClient.getCoalitionsInfo(userID: String(userData.id)) { (response, error) in
            guard let response = response else {
                SharedHelperMethods.showFailureAlert(title: "An error has occured", message: error!.localizedDescription, controller: self)
                return
            }
            if response.count > 0 {
                self.coalitionLabel.text = response[0].name
                self.levelBar.progressTintColor = SharedHelperMethods.hexStringToUIColor(hex: response[0].color)
                self.logoutButton.tintColor = self.levelBar.progressTintColor
                self.followedUsersButton.tintColor = self.levelBar.progressTintColor
                self.searchButton.tintColor = self.levelBar.progressTintColor
                if let coverURL = response[0].coverURL {
                    self.setImages(url: URL(string: coverURL)!, imageView: self.backgroundImageView, indicator: nil)
                }
            }
            if !self.userId.isEmpty {
                self.followButton.isHidden = false
            }
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
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "follow") {
            let newUser = FollowedUser(context: dataController.viewContext)
            newUser.userId = userId
            newUser.userImage = userImageView.image?.pngData()
            newUser.displayName = userData.displayname
            newUser.backgroundImage = backgroundImageView.image?.pngData()
            dataController.saveContext()
            let info = UIAlertController(title: "Followed!", message: "", preferredStyle: .actionSheet)
            info.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(info, animated: true, completion: nil)
            sender.setImage(UIImage(named: "unfollow"), for: UIControl.State.normal)
        }
        else {
            guard let followedUser = followUserData else {
                return
            }
            dataController.viewContext.delete(followedUser)
            dataController.saveContext()
            sender.setImage(UIImage(named: "follow"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        FortyTwoAPIClient.AuthenticationInfo.token = ""
        FortyTwoAPIClient.AuthenticationInfo.refreshToken = ""
        FortyTwoAPIClient.AuthenticationInfo.tokenExpieryDate = 0
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "expieryDate")
        self.dismiss(animated: true, completion: nil)
    }
}
