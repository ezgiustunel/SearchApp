//
//  API.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

protocol SearchAPIProtocol {
    func performRequest(completion:@escaping (Result<SearchResponseModel, Error>) -> Void)
    func parseJSON(data: Data, completion:@escaping (Result<SearchResponseModel, Error>) -> Void)
}

class APIService: SearchAPIProtocol {
    let request: URLRequest
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func performRequest(completion:@escaping (Result<SearchResponseModel, Error>) -> Void) {
        let dataTask = session.dataTask(with: self.request) { (data, response, error) in
            if error != nil {
                completion(.failure(CustomError.errorWithMessage(message: "error")))
            }
            if let safeData = data {
                self.parseJSON(data: safeData) { result in
                    switch result {
                    case .success(let response):
                        completion(.success(response))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func parseJSON(data: Data, completion:@escaping (Result<SearchResponseModel, Error>) -> Void) {
        let decoder = JSONDecoder()
        do {
            var items = SearchResponseModel()
            items = try decoder.decode(SearchResponseModel.self, from: data)
            completion(.success(items))
        } catch {
            completion(.failure(error))
            print(error)
        }
    }
}
