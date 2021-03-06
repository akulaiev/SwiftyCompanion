//
//  UserInfoViewController.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 28.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import UIKit
import CoreData

// Displays authorised user info, or followed/searched users

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
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var skillsButton: UIButton!
    @IBOutlet weak var projectsButton: UIButton!
    
    var userId: String = ""
    var dataController: DataController = AppDelegate.dataController
    var userData: UserData!
    var followedUser: FollowedUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skillsButton.layer.cornerRadius = 5
        projectsButton.layer.cornerRadius = 5
    }
    
    fileprivate func reloadViewContents() {
        userImageView.image = nil
        usernameLabel.text = "Username (login)"
        levelBar.progress = 0.5
        levelLabel.text = "XP"
        walletLabel.text = "0"
        correctionPointsLabel.text = "0"
        coalitionLabel.text = "-"
        rankLabel.text = "-"
        campusCityLabel.text = "-"
        backgroundImageView.image = UIImage(named: "greyTexture")
        levelBar.tintColor = UIColor.darkGray
        logoutButton.tintColor = UIColor.darkGray
        followedUsersButton.tintColor = UIColor.darkGray
        followButton.setImage(UIImage(named: "follow"), for: UIControl.State.normal)
        followButton.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        reloadViewContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        followButton.isEnabled = false
        followButton.isHidden = true
        projectsButton.isEnabled = false
        skillsButton.isEnabled = false
        if userId.isEmpty {
            getUserData()
        }
        else {
            guard let followedUserData = checkFollowedUser() else {
                getUserData()
                return
            }
            followedUser = followedUserData
            followButton.isHidden = false
            followButton.isEnabled = true
            projectsButton.isEnabled = true
            skillsButton.isEnabled = true
            userData = UserData(backgroundImage: followedUserData.backgroundImage ?? nil, city: followedUserData.city ?? "-", coalition: followedUserData.coalition ?? "-", color: followedUserData.color ?? "#ffffff", correctionPoints: followedUserData.correctionPoints ?? "0", displayName: followedUserData.displayName ?? "-", grade: followedUserData.grade ?? "-", level: followedUserData.level, login: followedUserData.login ?? "-", userId: followedUserData.userId ?? "", userImage: followedUserData.userImage ?? nil, wallet: followedUserData.wallet ?? "-", skillNames: followedUserData.skillNames ?? [], skillLevels: followedUserData.skillLevels ?? [], projectNames: followedUserData.projectNames ?? [], projectStatus: followedUserData.projectStatus ?? [], projectsValidated: followedUserData.projectsValidated ?? [])
            followButton.setImage(UIImage(named: "unfollow"), for: UIControl.State.normal)
            userImageView.image = UIImage(data: userData.userImage!)
            backgroundImageView.image = UIImage(data: userData.backgroundImage!)
            setInfoLabels()
        }
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
            if !self.userId.isEmpty {
                self.followButton.isEnabled = true
                self.followButton.isHidden = false
                self.projectsButton.isEnabled = true
                self.skillsButton.isEnabled = true
            }
        }
    }
    
    func setInfoLabels() {
        walletLabel.text = String(userData.wallet)
        correctionPointsLabel.text = String(userData.correctionPoints)
        usernameLabel.text = userData.displayName + " (" + userData.login + ")"
        levelLabel.text = String(userData.level)
        levelBar.progress = Float(userData.level - Float(Int(userData.level)))
        rankLabel.text = userData.grade
        campusCityLabel.text = userData.city
        coalitionLabel.text = userData.coalition
        levelBar.progressTintColor = SharedHelperMethods.hexStringToUIColor(hex: userData.color)
        logoutButton.tintColor = levelBar.progressTintColor
        followedUsersButton.tintColor = levelBar.progressTintColor
    }

    fileprivate func setUserData(_ coalition: CoalitionsResponse, user: UserResponse) {
        var skillNames: [String] = []
        var skillLevels: [Double] = []
        var projectNames: [String] = []
        var projectStatus: [String] = []
        var projectsValidated: [Bool] = []
        for project in user.projectsUsers {
            let projectName = project.project.slug.replacingOccurrences(of: "-", with: " ")
            let nameCap = projectName.capitalized
            projectNames.append(nameCap)
            projectStatus.append(project.status)
            projectsValidated.append(project.validated ?? false)
        }
        self.userData = UserData(backgroundImage: (self.backgroundImageView.image?.pngData()) ?? nil, city: "-", coalition: "-", color: "#ffffff", correctionPoints: String(user.correctionPoint), displayName: user.displayname, grade: "-", level: 0, login: user.login, userId: String(user.id), userImage: (self.userImageView.image?.pngData()) ?? nil, wallet: String(user.wallet), skillNames: [], skillLevels: [], projectNames: projectNames, projectStatus: projectStatus, projectsValidated: projectsValidated)
        if user.campus.count > 0 {
            self.userData.city = user.campus[0].country + ", " + user.campus[0].city
        }
        if user.cursusUsers.count > 0 {
            var cursusNum = 0
            while cursusNum < user.cursusUsers.count - 1, user.cursusUsers[cursusNum].cursus.name != "42" {
                cursusNum += 1
            }
            self.userData.grade = user.cursusUsers[cursusNum].grade ?? "-"
            self.userData.level = Float(user.cursusUsers[cursusNum].level)
            for skill in user.cursusUsers[cursusNum].skills {
                skillNames.append(skill.name)
                skillLevels.append(skill.level)
            }
            self.userData.skillNames = skillNames
            self.userData.skillLevels = skillLevels
        }
        if coalition.count > 0, let coverStr = coalition[0].coverURL, let coverURL = URL(string: coverStr) {
            self.setImages(url: coverURL, imageView: self.backgroundImageView, indicator: nil)
            self.userData.coalition = coalition[0].name
            self.userData.color = coalition[0].color
        }
    }
    
    fileprivate func getUserData() {
        activityIndicator.startAnimating()
        FortyTwoAPIClient.getUserInfo(userId: userId) {(response, error) in
            guard let user = response else {
                SharedHelperMethods.showFailureAlert(title: "An error has occured", message: error!.localizedDescription, controller: self)
                return
            }
            FortyTwoAPIClient.getCoalitionsInfo(userID: String(user.id)) { (response, error) in
                guard let coalition = response else {
                    SharedHelperMethods.showFailureAlert(title: "An error has occured", message: error!.localizedDescription, controller: self)
                    return
                }
                self.setImages(url: URL(string: user.imageURL)!, imageView: self.userImageView, indicator: self.activityIndicator)
                self.setUserData(coalition, user: user)
                self.setInfoLabels()
            }
        }
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "follow") {
            let newUser = FollowedUser(context: dataController.viewContext)
            newUser.userId = userId
            newUser.userImage = userImageView.image?.pngData()
            newUser.backgroundImage = backgroundImageView.image?.pngData()
            newUser.city = userData.city
            newUser.coalition = userData.coalition
            newUser.color = userData.color
            newUser.correctionPoints = userData.correctionPoints
            newUser.displayName = userData.displayName
            newUser.grade = userData.grade
            newUser.level = userData.level
            newUser.login = userData.login
            newUser.wallet = userData.wallet
            newUser.skillLevels = userData.skillLevels
            newUser.skillNames = userData.skillNames
            newUser.projectNames = userData.projectNames
            newUser.projectStatus = userData.projectStatus
            newUser.projectsValidated = userData.projectsValidated
            dataController.saveContext()
            SharedHelperMethods.showFailureAlert(title: "Followed!", message: "", controller: self)
            sender.setImage(UIImage(named: "unfollow"), for: UIControl.State.normal)
        }
        else {
            guard let followedUser = followedUser else {
                return
            }
            dataController.viewContext.delete(followedUser)
            dataController.saveContext()
            SharedHelperMethods.showFailureAlert(title: "Unfollowed!", message: "", controller: self)
            sender.setImage(UIImage(named: "follow"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        reloadViewContents()
        followButton.setImage(UIImage(named: "unfollow"), for: UIControl.State.normal)
        getUserData()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        SharedHelperMethods.logoutLogic(currentVC: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSkills" {
            let skillsVC = segue.destination as! SkillsViewController
            var skills: [String : Double] = [:]
            for i in 0..<userData.skillNames.count {
                skills[userData.skillNames[i]] = userData.skillLevels[i]
            }
            skillsVC.skills = skills
            skillsVC.color = userData.color
        }
        else if segue.identifier == "toProjects" {
            let projectsVC = segue.destination as! ProjectsViewController
            projectsVC.projectNames = userData.projectNames
            projectsVC.projectStatus = userData.projectStatus
            projectsVC.projectsValidated = userData.projectsValidated
        }
    }
}

// Struct with displayed user info
struct UserData {
    
    var backgroundImage: Data?
    var userImage: Data?
    var city: String
    var coalition: String
    var color: String
    var correctionPoints: String
    var displayName: String
    var grade: String
    var level: Float
    var login: String
    var userId: String
    var wallet: String
    var skillNames: [String]
    var skillLevels: [Double]
    var projectNames: [String]
    var projectStatus: [String]
    var projectsValidated: [Bool]
    
    init(backgroundImage: Data?, city: String, coalition: String, color: String, correctionPoints: String, displayName: String, grade: String, level: Float, login: String, userId: String, userImage: Data?, wallet: String, skillNames: [String], skillLevels: [Double], projectNames: [String], projectStatus: [String], projectsValidated: [Bool]) {
        if let backgroundImage = backgroundImage, let userImage = userImage {
            self.backgroundImage = backgroundImage
            self.userImage = userImage
        }
        else {
            self.backgroundImage = nil
            self.userImage = nil
        }
        self.city = city
        self.coalition = coalition
        self.color = color
        self.correctionPoints = correctionPoints
        self.displayName = displayName
        self.grade = grade
        self.level = level
        self.login = login
        self.userId = userId
        self.wallet = wallet
        self.skillNames = skillNames
        self.skillLevels = skillLevels
        self.projectNames = projectNames
        self.projectStatus = projectStatus
        self.projectsValidated = projectsValidated
    }
}
