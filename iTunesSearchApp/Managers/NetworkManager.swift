//
//  NetworkManager.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import UIKit

final class NetworkManager {
    static var shared = NetworkManager()
    private var images = NSCache<NSString, NSData>()
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func downloadAllImages(_ urls: [String], completion: @escaping ([UIImage]) -> Void) {
        let queue = DispatchQueue(label: "com.gcd.iTuneSearchQueue", qos: .utility, attributes: .concurrent)
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 3)
        var allImages = [UIImage]()
        
        for url in urls {
            group.enter()
            queue.async {
                semaphore.wait()
                self.image(imageURL: url) { data, error in
                    defer {
                        semaphore.signal()
                        group.leave()
                    }
                    if error == nil {
                        if let data = data {
                            allImages.append(UIImage(data: data) ?? UIImage())
                        }
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(allImages)
        }
    }
    
    private func image(imageURL: String, completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: imageURL)!
        downloadImage(imageURL: url, completion: completion)
    }
    
    private func downloadImage(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
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
                print("EZGI SIZE : ", localUrl.fileSize)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
