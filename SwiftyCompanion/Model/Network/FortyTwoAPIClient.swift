//
//  FortyTwoAPIClient.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 26.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import Foundation

class FortyTwoAPIClient {

    struct AuthenticationInfo {
        static var UID: String = "f29092fb5aff7b5d2fc123ccad8892830e50e4159e82050c808c5f867a117a46"
        static var secret: String = "58ce889ea553f067dfc7e0a080a51458b7cb0aee1d99da615a626ffdfc862730"
        static var token: String = ""
        static var refreshToken: String = ""
        static var tokenExpieryDate: Int = 0
        static var authUrlString: String = "https://api.intra.42.fr/oauth/authorize?client_id=f29092fb5aff7b5d2fc123ccad8892830e50e4159e82050c808c5f867a117a46&redirect_uri=swiftycompanion%3A%2F%2Fmain&scope=public+projects+profile+forum&response_type=code"
        static var code: String = ""
    }
    
    enum Endpoints {
        static let baseString = "https://api.intra.42.fr"
        
        case token
        case me

        var stringValue: String {
            switch self {
            case .token: return Endpoints.baseString + "/oauth/token"
            case .me: return Endpoints.baseString + "/v2/me"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
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
    
    class func getMyInfo(completion: @escaping (MeResponse?, Error?) -> Void) {
        print("!" + AuthenticationInfo.token + "!")
        let emptyBody: String? = nil
        NetworkingTasks.taskForRequest(authRequest: false, requestMethod: "GET", url: FortyTwoAPIClient.Endpoints.me.url, responseType: MeResponse.self, body: emptyBody) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(response, nil)
        }
    }

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
}
