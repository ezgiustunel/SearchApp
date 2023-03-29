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
    func fetchSearchItems()
    func filterSearchWith(term: String)
    func loadScreenShotImages(items: [SearchModel])
}

final class SearchInteractor: SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol?
    var worker: SearchWorkerProtocol = SearchWorker()
    private var termText = "world"
    
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
                    } else {
                        self.presenter?.presentNoData()
                    }
                }
            }
        }
    }
    
    func fetchSearchItems() {
        self.presenter?.presentLoading()
        worker.getSearchItems(term: termText) { result in
            switch result {
            case .success(let response):
                if (response.results.count > 0) {
                    self.loadScreenShotImages(items: response.results)
                } else {
                    self.presenter?.presentNoData()
                }
            case .failure(_):
                self.presenter?.presentNoData()
            }
        }
    }
    
    func filterSearchWith(term: String) {
        termText = term
        presenter?.cleanAllItems()
        fetchSearchItems()
    }
    
    func loadScreenShotImages(items: [SearchModel]) {
        var allImageUrls = [String]()
        
        for item in items {
            allImageUrls.append(contentsOf: item.screenshotUrls)
        }
        
        fetchImages(allImageUrls)
    }
}
