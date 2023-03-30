//
//  ImageService.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 28.03.2023.
//

import Foundation

protocol ImageServiceProtocol {
    func image(imageURL: String, completion: @escaping (Data?, Error?) -> (Void))
    func downloadImage(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void))
}

final class ImageService: ImageServiceProtocol {
    private var images = NSCache<NSString, NSData>()
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func image(imageURL: String, completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: imageURL)!
        downloadImage(imageURL: url, completion: completion)
    }
    
    func downloadImage(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        let task = session.downloadTask(with: imageURL) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let localUrl = localUrl else {
                completion(nil, CustomError.errorWithMessage(message: "error"))
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
