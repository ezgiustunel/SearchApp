//
//  SearchModel.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
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
