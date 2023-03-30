//
//  SearchVMTests.swift
//  iTunesSearchAppTests
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import XCTest

@testable import iTunesSearchApp

final class SearchInteractorTests: XCTestCase {
    var interactor: SearchInteractor!

    override func setUp() {
        interactor = SearchInteractor()
    }
    
    func testFetchItemsSuccess() {
        interactor.fetchSearchItems()
        let mockService = MockSearchService()
        guard let mockItems = mockService.searchItems() else { return }
        XCTAssertEqual(interactor.totalItems, mockItems.results.count)
    }
    
    func testFetchItemsError() {
        interactor.fetchSearchItems()
        XCTAssertEqual(interactor.totalItems, 0)
    }
}
