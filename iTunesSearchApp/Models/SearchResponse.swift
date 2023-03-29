//
//  SearchResponse.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 28.03.2023.
//

import Foundation

struct SearchModel: Codable {
    var screenshotUrls: [String]
    
    enum CodingKeys: String, CodingKey {
        case screenshotUrls = "screenshotUrls"
    }
    
    init() {
        screenshotUrls = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        screenshotUrls = try container.decode([String].self, forKey: .screenshotUrls)
    }
}

struct SearchResponseModel: Codable {
    var results: [SearchModel]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    init() {
        results = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([SearchModel].self, forKey: .results)
    }
}
