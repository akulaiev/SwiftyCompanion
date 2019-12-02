//
//  NetworkingTasks.swift
//  OnTheMap
//
//  Created by Anna KULAIEVA on 10/24/19.
//  Copyright © 2019 Anna Kulaieva. All rights reserved.
//

import Foundation
import UIKit

class NetworkingTasks {
    
    //Static function to perform all kinds of networking requests
    class func taskForRequest<RequestType: Encodable, ResponseType: Decodable>(authRequest: Bool, requestMethod: String, url: URL, responseType: ResponseType.Type, body: RequestType?, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !authRequest {
            if !SharedHelperMethods.checkExpiredToken() {
                request.addValue("Bearer " + FortyTwoAPIClient.AuthenticationInfo.token, forHTTPHeaderField: "Authorization")
            }
            else {
                FortyTwoAPIClient.refreshAuthToken { (success, error) in
                    if !success {
                        SharedHelperMethods.showFailureAlert(title: "Login Error", message: error!.localizedDescription, controller: nil)
                    }
                }
            }
        }
        if let body = body {
            request.httpBody = try! JSONEncoder().encode(body)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
}
