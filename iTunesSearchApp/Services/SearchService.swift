//
//  SearchService.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

protocol SearchServiceProtocol {
    func getItems(term: String, completion: @escaping (Result<SearchResponseModel, Error>) -> Void)
}

final class SearchService: SearchServiceProtocol {
    func getItems(term: String, completion: @escaping (Result<SearchResponseModel, Error>) -> Void) {
        
        APIService.performRequest(route: APIRouter.search(term: term)) { (result:(Result<SearchResponseModel?, Error>)) in
            switch result {
            case .success(let response):
                if let response = response {
                    completion(.success(response))
                } else {
                    completion(.success(SearchResponseModel()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
