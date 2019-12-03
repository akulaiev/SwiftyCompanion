//
//  FortyTwoCoalitionsResponse.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 02.12.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import Foundation

struct CoalitionsResponseElement: Codable {
    let id: Int
    let name, slug: String
    let imageURL: String
    let coverURL: String
    let color: String
    let score, userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case imageURL = "image_url"
        case coverURL = "cover_url"
        case color, score
        case userID = "user_id"
    }
}

typealias CoalitionsResponse = [CoalitionsResponseElement]
