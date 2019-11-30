//
//  FortyTwoMeResponse.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 29.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import Foundation

struct MeResponse: Codable {
    let id: Int
    let email, login: String
    let url: String
    let phone, displayname: String
    let imageURL: String
    let staff: Bool
    let correctionPoint: Int
    let poolMonth, poolYear: String
    let wallet: Int
    let cursusUsers: [CursusUser]
    
    enum CodingKeys: String, CodingKey {
        case id, email, login, url, phone, displayname
        case imageURL = "image_url"
        case staff = "staff?"
        case correctionPoint = "correction_point"
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case wallet
        case cursusUsers = "cursus_users"
    }
}

struct CursusUser: Codable {
    let grade: String
    let level: Double
//    let skills: [Skill]
//    let hasCoalition: Bool
    
//    enum CodingKeys: String, CodingKey {
//        case grade, level, skills
//        case hasCoalition = "has_coalition"
//    }
}

// MARK: - Skill
struct Skill: Codable {
    let name: String
    let level: Double
}
