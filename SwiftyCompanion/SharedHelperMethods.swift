//
//  SharedHelperMethods.swift
//  OnTheMap
//
//  Created by Anna Koulaeva on 28.10.2019.
//  Copyright © 2019 Anna Kulaieva. All rights reserved.
//

import Foundation
import UIKit

class SharedHelperMethods {
    
    //Shows error alerts
    static func showFailureAlert(title: String, message: String, controller: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alertVC, animated: true)
    }
    
    //Updates controllers' UI while requests are performed
    static func updateUIState(isLoading: Bool, activityIndicator: UIActivityIndicatorView, textfieldOne: UITextField, textfieldTwo: UITextField, button: UIButton, buttonOptional: UIButton?) {
        if isLoading {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
        textfieldOne.isEnabled = !isLoading
        textfieldTwo.isEnabled = !isLoading
        button.isEnabled = !isLoading
        if let buttonOptional = buttonOptional {
            buttonOptional.isEnabled = !isLoading
        }
    }
    
    class func checkExpiredToken() -> Bool {
        let currentDateInterval = Int(Date().timeIntervalSince1970)
        if FortyTwoAPIClient.AuthenticationInfo.tokenExpieryDate > 0, currentDateInterval < FortyTwoAPIClient.AuthenticationInfo.tokenExpieryDate {
            return false
        }
        else {
            return true
        }
    }
}
