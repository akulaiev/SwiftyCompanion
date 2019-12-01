//
//  AuthenticationViewController.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 26.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var browseButton: UIButton!
    
    fileprivate func updateUI(login: Bool) {
        loginButton.isEnabled = login
        loginButton.isHidden = !login
        browseButton.isEnabled = !login
        browseButton.isHidden = login
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        browseButton.layer.cornerRadius = 5
        if let token = UserDefaults.standard.object(forKey: "accessToken") {
            updateUI(login: false)
            if let expieryDate = UserDefaults.standard.object(forKey: "expieryDate"), let refreshToken = UserDefaults.standard.object(forKey: "refreshToken") {
                FortyTwoAPIClient.AuthenticationInfo.refreshToken = refreshToken as! String
                FortyTwoAPIClient.AuthenticationInfo.tokenExpieryDate = expieryDate as! Int
                FortyTwoAPIClient.AuthenticationInfo.token = token as! String
                if SharedHelperMethods.checkExpiredToken() {
                    FortyTwoAPIClient.refreshAuthToken()
                }
            }
        }
        else {
            updateUI(login: true)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: FortyTwoAPIClient.AuthenticationInfo.authUrlString)!, options: [:], completionHandler: nil)
        
    }
}
