//
//  FortyTwoAPIClient.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 26.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import Foundation

class FortyTwoAPIClient {

    // Data, needed for Authentication
    struct AuthenticationInfo {
        static var UID: String = "f29092fb5aff7b5d2fc123ccad8892830e50e4159e82050c808c5f867a117a46"
        static var secret: String = "58ce889ea553f067dfc7e0a080a51458b7cb0aee1d99da615a626ffdfc862730"
        static var token: String = ""
        static var refreshToken: String = ""
        static var tokenExpieryDate: Int = 0
        static var authUrlString: String = "https://api.intra.42.fr/oauth/authorize?client_id=f29092fb5aff7b5d2fc123ccad8892830e50e4159e82050c808c5f867a117a46&redirect_uri=swiftycompanion%3A%2F%2Fmain&scope=public+projects+profile+forum&response_type=code"
        static var code: String = ""
    }
    
    // API endpoints
    enum Endpoints {
        static let baseString = "https://api.intra.42.fr"
        
        case token
        case me
        case search

        var stringValue: String {
            switch self {
            case .token: return Endpoints.baseString + "/oauth/token"
            case .me: return Endpoints.baseString + "/v2/me"
            case .search: return Endpoints.baseString + "/v2/users"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // Different API data queries
    
    class func getCoalitionsInfo(userID: String, completion: @escaping (CoalitionsResponse?, Error?) -> Void) {
        let emptyBody: String? = nil
        let url = URL(string: Endpoints.baseString + "/v2/users/" + userID + "/coalitions")!
        NetworkingTasks.taskForRequest(authRequest: false, requestMethod: "GET", url: url, responseType: CoalitionsResponse.self, body: emptyBody) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(response, nil)
        }
    }
    
    class func getUserInfo(userId: String, completion: @escaping (UserResponse?, Error?) -> Void) {
        let emptyBody: String? = nil
        var urlStr = ""
        if userId.isEmpty {
            urlStr = Endpoints.me.stringValue
        }
        else {
            urlStr = Endpoints.search.stringValue + "/" + userId
        }
        NetworkingTasks.taskForRequest(authRequest: false, requestMethod: "GET", url: URL(string: urlStr)!, responseType: UserResponse.self, body: emptyBody) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(response, nil)
        }
    }

    // Helper function to set and persist token values
    private class func setTokenValues(_ response: TokenResponse) {
        AuthenticationInfo.token = response.accessToken
        AuthenticationInfo.refreshToken = response.refreshToken
        AuthenticationInfo.tokenExpieryDate = response.createdAt + response.expieresIn
        UserDefaults.standard.set(AuthenticationInfo.token, forKey: "accessToken")
        UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
        UserDefaults.standard.set(AuthenticationInfo.tokenExpieryDate, forKey: "expieryDate")
    }
    
    class func refreshAuthToken(completion: @escaping (Bool, Error?) -> Void) {
        if !AuthenticationInfo.refreshToken.isEmpty {
            let body = RefreshTokenRequest(grantType: "refresh_token", refreshToken: AuthenticationInfo.refreshToken, scope: "public projects profile forum", clientId: AuthenticationInfo.UID, clientSecret: AuthenticationInfo.secret)
            NetworkingTasks.taskForRequest(authRequest: true, requestMethod: "POST", url: Endpoints.token.url, responseType: TokenResponse.self, body: body) { (response, error) in
                guard let response = response else {
                    completion(false, error)
                    return
                }
                self.setTokenValues(response)
                completion(true, nil)
            }
        }
    }
    
    class func getAccessToken(completion: @escaping (Bool, Error?) -> Void) {
        let body = TokenRequest(grantType: "authorization_code", clientId: AuthenticationInfo.UID, clientSecret: AuthenticationInfo.secret, code: AuthenticationInfo.code, scope: "public projects profile forum", responseType: "code", redirectUri: "swiftycompanion://main")
        NetworkingTasks.taskForRequest(authRequest: true, requestMethod: "POST", url: Endpoints.token.url, responseType: TokenResponse.self, body: body) { (response, error) in
            guard let response = response else {
                completion(false, error)
                return
            }
            self.setTokenValues(response)
            completion(true, nil)
        }
    }
    
    // Helper function for autocomplete request
    private class func getMaxValue(minValue: String) -> String {
        let alphStr = "abcdefghijklmnopqrstuvwxyz"
        var minValLowerCase = minValue.lowercased()
        var hasZ = false
        var resStr = ""
        
        if !minValLowerCase.isEmpty {
            while minValLowerCase.count > 0, minValLowerCase.last == "z" {
                hasZ = true
                minValLowerCase = String(minValLowerCase.dropLast())
            }
            if hasZ, minValLowerCase.count == 0 {
                resStr = minValue.lowercased() + "z"
            }
            else {
                let strIndx = alphStr.firstIndex(of: minValLowerCase.last!)
                if let strIndx = strIndx {
                    resStr = String(minValLowerCase.dropLast()) + String(alphStr[alphStr.index(strIndx, offsetBy: 1)])
                }
            }
        }
        return resStr
    }
    
    class func search(query: String, completion: @escaping (SearchResponse, Error?) -> Void) -> URLSessionTask {
        let emptyBody: String? = nil
        let url = URL(string: Endpoints.search.stringValue + "?range[login]=" + query.lowercased() + "," + getMaxValue(minValue: query))!
        let task = NetworkingTasks.taskForRequest(authRequest: false, requestMethod: "GET", url: url, responseType: SearchResponse.self, body: emptyBody) { (response, error) in
            if let response = response {
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            }
            else {
                DispatchQueue.main.async {
                    print(error!.localizedDescription)
                    completion([], error)
                }
            }
        }
        return task
    }
}
