//
//  SharedHelperMethods.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 28.10.2019.
//  Copyright © 2019 Anna Kulaieva. All rights reserved.
//

import Foundation
import UIKit

class SharedHelperMethods {
    
    // Shows error alerts
    static func showFailureAlert(title: String, message: String, controller: UIViewController?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let controller = controller {
            controller.present(alertVC, animated: true)
        }
        else {
            let viewController = UIApplication.shared.windows.first!.rootViewController as! AuthenticationViewController
            viewController.present(alertVC, animated: true)
        }
    }
    
    // Updates controllers' UI while requests are performed
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
    
    // Checks saved token ex spiery time stamp
    class func checkExpiredToken() -> Bool {
        let currentDateInterval = Int(Date().timeIntervalSince1970)
        if FortyTwoAPIClient.AuthenticationInfo.tokenExpieryDate > 0, currentDateInterval < FortyTwoAPIClient.AuthenticationInfo.tokenExpieryDate {
            return false
        }
        else {
            return true
        }
    }
    
    // Casts string to UIColor
    class func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Logout logic
    class func logoutLogic(currentVC: UIViewController) {
        FortyTwoAPIClient.AuthenticationInfo.token = ""
        FortyTwoAPIClient.AuthenticationInfo.refreshToken = ""
        FortyTwoAPIClient.AuthenticationInfo.tokenExpieryDate = 0
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "expieryDate")
        currentVC.dismiss(animated: true, completion: nil)
    }
}
