//
//  SearchVM.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import UIKit

final class SearchVM: ObservableObject {
    @Published var response = SearchResponseModel()
    var allImages = [UIImage]()
    private let searchService: SearchServiceDelegate
    
    init(searchService: SearchServiceDelegate = SearchService()) {
        self.searchService = searchService
    }
    
    func loadItems(term: String) {
        ImageHelper.shared.cleanAllItems()
        searchService.getItems(term: term) { result in
            switch result {
            case .success(let response):
                self.response = response
                self.loadScreenShotImages(items: self.response.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadScreenShotImages(items: [SearchModel]) {
        var allImageUrls = [String]()
        
        for item in items {
            allImageUrls.append(contentsOf: item.screenshotUrls)
        }
                    
        NetworkManager.shared.downloadAllImages(allImageUrls) { result in
            self.allImages = result
        }
    }
}
