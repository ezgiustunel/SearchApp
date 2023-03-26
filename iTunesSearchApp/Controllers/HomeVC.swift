//
//  HomeVC.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 24.03.2023.
//

import UIKit

final class HomeVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    var searchVM = SearchVM()
    var imageSections = [ImageSection]()
    
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
        searchController.searchBar.returnKeyType = .search
        navigationItem.searchController = searchController
        
        //CollectionView
        let customCellNib: UINib = UINib(nibName: "ImageCVC", bundle: nil)
        collectionView.register(customCellNib, forCellWithReuseIdentifier: "ImageCVC")
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setupData() {
        searchVM.loadItems(term: "apple")
    }
    
    // MARK: - Setup
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            //guard let self = self else { return  }
            let section = self?.imageSections[sectionIndex]
            switch section {
            case .lessOrEqual100kb:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.3)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 10)
                //section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            case .between101and250kb:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.4)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 10)
                //section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            case .between251and500kb:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(0.5)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 10)
                //section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
                
            case .higherThan500kb:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.6)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 10)
                //section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            case .none:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(170), heightDimension: .absolute(80)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
                //section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            }
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    // MARK: - Notification
    @objc func reloadCollectionView() {
        imageSections = ImageHelper.getImageSections(images: searchVM.allImages)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imageSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVC", for: indexPath) as! ImageCVC

        switch imageSections[indexPath.section] {
        case .lessOrEqual100kb(let items):
            cell.setData(imageModel: items[indexPath.row])
        case .between101and250kb(let items):
            cell.setData(imageModel: items[indexPath.row])
        case .between251and500kb(let items):
            cell.setData(imageModel: items[indexPath.row])
        case .higherThan500kb(let items):
            cell.setData(imageModel: items[indexPath.row])
        }
        return cell
    }
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeaderReusableView", for: indexPath) as! CollectionViewHeaderReusableView
            header.setup(imageSections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }*/
}

extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchVM.loadItems(term: searchText)
    }
}
