//
//  SearchVM.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation


final class SearchVM: ObservableObject {

    @Published var response = SearchResponseModel()
    private let searchService: SearchServiceDelegate
    
    init(searchService: SearchServiceDelegate = SearchService()) {
        self.searchService = searchService
    }
    
    func loadItems(term: String) {
        searchService.getItems(term: term) { result in
            switch result {
            case .success(let response):
                self.response = response
                //self.loadScreenShotImages(items: self.response.results)
            case .failure(let error):
                //NotificationCenter.default.post(name: NSNotification.Name.SearchAPIFailure, object: nil)
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadScreenShotImages(items: [SearchModel]) {
        let group = DispatchGroup()

        for item in items {
            for url in item.screenshotUrls {
                group.enter()
                NetworkManager.shared.image(imageURL: url) { data, error in
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            //NotificationCenter.default.post(name: NSNotification.Name.ReloadImageCollectionView, object: nil)
        }
    }
}
