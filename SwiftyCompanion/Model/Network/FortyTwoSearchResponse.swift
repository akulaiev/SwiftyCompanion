//
//  FortyTwoSearchResponse.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 04.12.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import Foundation

// MARK: - SearchResponseElement
struct SearchResponseElement: Codable {
    let id: Int
    let login: String
    let url: String
}

typealias SearchResponse = [SearchResponseElement]
