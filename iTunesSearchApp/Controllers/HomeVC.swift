//
//  HomeVC.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 24.03.2023.
//

import UIKit

final class HomeVC: UIViewController, UISearchBarDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    var searchVM = SearchVM()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.systemOrange
        navigationItem.searchController = searchController
    }
    
    private func setupData() {
        searchVM.loadItems(term: "instagram")
    }
}
