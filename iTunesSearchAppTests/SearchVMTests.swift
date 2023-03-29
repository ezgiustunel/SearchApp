//
//  SearchVMTests.swift
//  iTunesSearchAppTests
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import XCTest

@testable import iTunesSearchApp

class SearchVMTests: XCTestCase {
    
    /*func test_API_failure() {
        let mockService = MockSearchService()
        mockService.result = .failure(CustomError.errorWithMessage(message: "no data"))
        let searchVM = SearchVM(searchService: mockService)
        searchVM.loadItems(term: "instagram")
        XCTAssert(searchVM.allImages.isEmpty)
    }
    
    func test_API_success() {
        let mockService = MockSearchService()
        guard let mockProducts = mockService.searchItems() else { return }
        mockService.result = .success(mockProducts)
        let searchVM = SearchVM(searchService: mockService)
        searchVM.loadItems(term: "instagram")
        XCTAssert(!searchVM.allImages.isEmpty)
    }*/
}
