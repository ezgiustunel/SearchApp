//
//  API.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

struct APIService {
    
    static func performRequest<T>(route: APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, Error>) -> Void) where T: Codable {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let dataTask = session.dataTask(with: route.request) { (data, response, error) in
            if error != nil {
                completion(.failure(CustomError.errorWithMessage(message: "error")))
            }
            if let safeData = data {
                guard let responseModel = try? decoder.decode(T.self, from: safeData) else {
                    completion(Result.failure(CustomError.errorWithMessage(message: "invalid")))
                    return
                }
                completion(.success(responseModel))
            } else {
                completion(Result.failure(CustomError.errorWithMessage(message: "invalid")))
            }
        }
        dataTask.resume()
    }
}
