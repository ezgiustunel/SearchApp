//
//  MockSearchService.swift
//  iTunesSearchAppTests
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

@testable import iTunesSearchApp

class MockSearchService: SearchServiceProtocol {
    var result: Result<SearchResponseModel, Error>!
    
    func getItems(term: String, completion: @escaping (Result<SearchResponseModel, Error>) -> Void) {
        completion(result)
    }
    
    func searchItems() -> SearchResponseModel? {
        do {
            guard let fileURL = Bundle.main.url(forResource: "SearchItems", withExtension: "json") else {
                return nil
            }
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(SearchResponseModel.self, from: data)
        } catch _ {
            return nil
        }
    }
}
