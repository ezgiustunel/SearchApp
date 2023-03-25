//
//  SearchResponseModel.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

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
