//
//  SearchWorker.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 28.03.2023.
//

import Foundation

protocol SearchWorkerProtocol {
    func getSearchItems(term: String, completion: @escaping (Result<SearchResponseModel, Error>) -> Void)
    func getImageData(imageUrl: String, completion: @escaping (Data?, Error?) -> Void)
}

final class SearchWorker: SearchWorkerProtocol {
    let searchService: SearchServiceProtocol = SearchService()
    let imageService: ImageServiceProtocol = ImageService()
    
    // MARK: Worker methods
    func getSearchItems(term: String, completion: @escaping (Result<SearchResponseModel, Error>) -> Void) {
        searchService.getItems(term: term) { result in
            completion(result)
        }
    }
    
    func getImageData(imageUrl: String, completion: @escaping (Data?, Error?) -> Void) {
        imageService.image(imageURL: imageUrl) { result, error in
            completion(result, error)
        }
    }
}
