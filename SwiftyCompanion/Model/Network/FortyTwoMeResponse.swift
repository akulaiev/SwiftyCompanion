//
//  FortyTwoMeResponse.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 29.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import Foundation

// MARK: - MeStruct
struct MeResponse: Codable {
    let id: Int
//    let email, login, firstName, lastName: String
//    let url: String
//    let phone, displayname: String
//    let imageURL: String
//    let staff: Bool
//    let correctionPoint: Int
//    let poolMonth, poolYear: String
//    let wallet: Int
//    let cursusUsers: [CursusUser]
//    let projectsUsers: [ProjectsUser]
//    let achievements: [Achievement]
//    let titles: [Title]
//    let campus: [Campus]
//    let campusUsers: [CampusUser]
    
    enum CodingKeys: String, CodingKey {
        case id//, email, login
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case url, phone, displayname
//        case imageURL = "image_url"
//        case staff = "staff?"
//        case correctionPoint = "correction_point"
//        case poolMonth = "pool_month"
//        case poolYear = "pool_year"
//        case wallet
//        case cursusUsers = "cursus_users"
//        case projectsUsers = "projects_users"
//        case achievements, titles, campus
//        case campusUsers = "campus_users"
    }
}

// MARK: - Achievement
struct Achievement: Codable {
    let id: Int
    let name, achievementDescription, tier, kind: String
    let visible: Bool
    let image: String
    let usersURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case achievementDescription = "description"
        case tier, kind, visible, image
        case usersURL = "users_url"
    }
}

// MARK: - Campus
struct Campus: Codable {
    let id: Int
    let name, timeZone: String
    let language: Language
    let usersCount, vogsphereID: Int
    let country, address, zip, city: String
    let website, facebook: String
    let twitter: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case timeZone = "time_zone"
        case language
        case usersCount = "users_count"
        case vogsphereID = "vogsphere_id"
        case country, address, zip, city, website, facebook, twitter
    }
}

// MARK: - Language
struct Language: Codable {
    let id: Int
    let name, identifier, createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, identifier
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CampusUser
struct CampusUser: Codable {
    let id, userID, campusID: Int
    let isPrimary: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case campusID = "campus_id"
        case isPrimary = "is_primary"
    }
}

// MARK: - CursusUser
struct CursusUser: Codable {
    let grade: String
    let level: Double
    let skills: [Skill]
    let id: Int
    let beginAt: String
    let cursusID: Int
    let hasCoalition: Bool
    let user: User
    let cursus: Cursus
    
    enum CodingKeys: String, CodingKey {
        case grade, level, skills, id
        case beginAt = "begin_at"
        case cursusID = "cursus_id"
        case hasCoalition = "has_coalition"
        case user, cursus
    }
}

// MARK: - Cursus
struct Cursus: Codable {
    let id: Int
    let createdAt: String?
    let name, slug: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name, slug
    }
}

// MARK: - Skill
struct Skill: Codable {
    let id: Int
    let name: String
    let level: Double
}

// MARK: - User
struct User: Codable {
    let id: Int
    let login: String
    let url: String
}

// MARK: - ProjectsUser
struct ProjectsUser: Codable {
    let id, occurrence, finalMark: Int
    let status: String
    let validated: Bool
    let currentTeamID: Int
    let project: Cursus
    let cursusIDS: [Int]
    let markedAt: String
    let marked: Bool
    let retriableAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, occurrence
        case finalMark = "final_mark"
        case status
        case validated = "validated?"
        case currentTeamID = "current_team_id"
        case project
        case cursusIDS = "cursus_ids"
        case markedAt = "marked_at"
        case marked
        case retriableAt = "retriable_at"
    }
}

// MARK: - Title
struct Title: Codable {
    let id: Int
    let name: String
}
