//
//  SearchInteractor.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 28.03.2023.
//

import Foundation

protocol SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    func fetchImages(_ urls: [String])
    func filterSearch(term: String)
    func loadScreenShotImages(items: [SearchModel])
}

final class SearchInteractor: SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol?
    var worker: SearchWorkerProtocol = SearchWorker()
    
    func fetchImages(_ urls: [String]) {
        let queue = DispatchQueue(label: "com.gcd.iTuneSearchQueue", qos: .utility, attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 3)
        
        for url in urls {
            queue.async {
                semaphore.wait()
                
                self.worker.getImageData(imageUrl: url) { data, error in
                    defer {
                        semaphore.signal()
                    }
                    if error == nil {
                        if let data = data {
                            self.presenter?.presentSearchData(imageModel: SearchList.ImageModel(imageData: data, categoryType: .lessOrEqual100kb))
                        }
                    }
                }
            }
        }
    }
    
    func filterSearch(term: String) {
        presenter?.cleanAllItems()
        worker.getSearchItems(term: term) { result, error in
            self.loadScreenShotImages(items: result.results)
        }
    }
    
    func loadScreenShotImages(items: [SearchModel]) {
        var allImageUrls = [String]()
        
        for item in items {
            allImageUrls.append(contentsOf: item.screenshotUrls)
        }
        
        fetchImages(allImageUrls)
    }
}
