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
        
        let searchEndpoint = APIRouter.search(term: term)
        let searchUrlRequest = searchEndpoint.request
        let api = APIService(request: searchUrlRequest)
        
        api.performRequest { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
