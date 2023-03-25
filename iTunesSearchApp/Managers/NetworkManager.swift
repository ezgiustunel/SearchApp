//
//  NetworkManager.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()
    private var images = NSCache<NSString, NSData>()
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    private func downloadImage(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
            completion(imageData as Data, nil)
            return
        }
        
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
                self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    func image(imageURL: String, completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: imageURL)!
        downloadImage(imageURL: url, completion: completion)
    }
}
