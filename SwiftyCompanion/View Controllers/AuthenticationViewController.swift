//
//  AuthenticationViewController.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 26.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import UIKit

// Checks for valid tokens and kicks OAuth to login

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var actionButton: UIButton!
    
    fileprivate func updateUI(login: Bool) {
        if login {
            actionButton.setTitle("LOG IN", for: .normal)
        }
        else {
            actionButton.setTitle("BROWSE", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let token = UserDefaults.standard.object(forKey: "accessToken") {
            self.updateUI(login: false)
            if let expieryDate = UserDefaults.standard.object(forKey: "expieryDate"), let refreshToken = UserDefaults.standard.object(forKey: "refreshToken") {
                FortyTwoAPIClient.AuthenticationInfo.refreshToken = refreshToken as! String
                FortyTwoAPIClient.AuthenticationInfo.tokenExpieryDate = expieryDate as! Int
                FortyTwoAPIClient.AuthenticationInfo.token = token as! String
                if SharedHelperMethods.checkExpiredToken() {
                    FortyTwoAPIClient.refreshAuthToken { (success, error) in
                        if !success {
                            SharedHelperMethods.showFailureAlert(title: "Session Expiered", message: error!.localizedDescription, controller: self)
                        }
                    }
                }
            }
        }
        else {
            updateUI(login: true)
        }
    }
     
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "LOG IN" {
            UIApplication.shared.open(URL(string: FortyTwoAPIClient.AuthenticationInfo.authUrlString)!, options: [:], completionHandler: nil)
        }
        else {
            performSegue(withIdentifier: "browse", sender: self)
        }
    }
}
