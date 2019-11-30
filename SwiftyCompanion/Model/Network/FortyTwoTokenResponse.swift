//
//  FortyTwoResponseStructs.swift
//  SwiftyCompanion
//
//  Created by Anna Kulaieva on 11/27/19.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import Foundation

struct TokenResponse: Codable {
    
    let accessToken: String
    let tokenType: String
    let expieresIn: Int
    let refreshToken: String
    let createdAt: Int
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expieresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
        case scope
    }
}
