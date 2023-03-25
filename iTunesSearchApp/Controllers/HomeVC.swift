//
//  HomeVC.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 24.03.2023.
//

import UIKit

final class HomeVC: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    var searchVM = SearchVM()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .ReloadImageCollectionView, object: nil)

        setupUI()
        setupData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .ReloadImageCollectionView, object: nil)
    }
    
    // MARK: - Setup
    private func setupUI() {
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.systemOrange
        navigationItem.searchController = searchController
    }
    
    private func setupData() {
        searchVM.loadItems(term: "apple")
    }
    
    //Notification
    @objc func reloadCollectionView() {
        let imagesWithCategories = ImageHelper.getAllImagesWithSizeCategories(images: searchVM.allImages)
        DispatchQueue.main.async {
            
        }
    }
    
    
    
    
    
    
    
    
}

extension HomeVC: UISearchBarDelegate {
    
}
