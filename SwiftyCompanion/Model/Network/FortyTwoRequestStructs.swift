//
//  FortyTwoRequestStructs.swift
//  SwiftyCompanion
//
//  Created by Anna Kulaieva on 11/27/19.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import Foundation

struct TokenRequest: Codable {
    
    let grantType: String
    let clientId: String
    let clientSecret: String
    let code: String
    let scope: String
    let responseType: String
    let redirectUri: String

    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectUri = "redirect_uri"
        case responseType = "response_type"
        case code
        case scope
    }
}
