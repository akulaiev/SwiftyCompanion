//
//  AuthenticationViewController.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 26.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: FortyTwoAPIClient.AuthenticationInfo.authUrlString)!, options: [:], completionHandler: nil)
        
    }
}
