//
//  SearchInteractor.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 28.03.2023.
//

import Foundation

protocol SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    func fetchSearchItems()
    func filterSearchWith(term: String)
    func loadScreenShotImages(items: [SearchModel])
    func fetchImages(_ urls: [String])
}

final class SearchInteractor: SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol?
    var worker: SearchWorkerProtocol = SearchWorker()
    var totalItems: Int = 0
    private var termText = "instagram"
    private var workItem: DispatchWorkItem = DispatchWorkItem {}
    private var threadNum: Int = 3
    
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
                self.totalItems = response.results.count
            case .failure(_):
                self.presenter?.presentNoData()
            }
        }
    }
    
    func filterSearchWith(term: String) {
        termText = term
        workItem.cancel()
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
    
    func fetchImages(_ urls: [String]) {
        let queue = DispatchQueue(label: "com.gcd.iTuneSearchQueue", qos: .utility, attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: threadNum)
        
        workItem = DispatchWorkItem {
            for url in urls {
                if (self.workItem.isCancelled) {
                    break
                }
                semaphore.wait()
                self.worker.getImageData(imageUrl: url) { data, error in
                    defer {
                        semaphore.signal()
                    }
                    if error == nil && !self.workItem.isCancelled {
                        if let data = data {
                            self.presenter?.presentSearchData(imageModel: SearchList.ImageModel(imageData: data, categoryType: .none))
                        } else {
                            self.presenter?.presentNoData()
                        }
                    } else {
                        self.presenter?.presentNoData()
                    }
                }
            }
        }
        queue.async(execute: workItem)
    }
}
