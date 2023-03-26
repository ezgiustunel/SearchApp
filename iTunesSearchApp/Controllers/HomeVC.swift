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
    private var searchVM = SearchVM()
    private var imageSections = [[SearchImageModel]]()
    private var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()
    
    typealias DataSource = UICollectionViewDiffableDataSource<ImageSection, SearchImageModel>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ImageSection, SearchImageModel>
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataSource), name: .ReloadImageCollectionView, object: nil)
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
        dataSource = configureDataSource()
    }
    
    // MARK: - CollectionView Diffable DataSource
    private func configureDataSource() -> UICollectionViewDiffableDataSource<ImageSection, SearchImageModel> {
        let dataSource = UICollectionViewDiffableDataSource<ImageSection, SearchImageModel>(collectionView: collectionView) { (collectionView, indexPath, imageModel) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVC", for: indexPath) as! ImageCVC
            cell.setData(imageModel: imageModel)
            return cell
        }
        return dataSource
    }
    
    @objc func updateDataSource() {
        imageSections = ImageHelper.shared.imageSectionData
        
        snapshot = DataSourceSnapshot()
        
        snapshot.appendSections([ImageSection.lessOrEqual100kb,
                                 ImageSection.between101and250kb,
                                 ImageSection.between251and500kb,
                                 ImageSection.higherThan500kb])
        
        snapshot.appendItems(imageSections[0], toSection: .lessOrEqual100kb)
        snapshot.appendItems(imageSections[1], toSection: .between101and250kb)
        snapshot.appendItems(imageSections[2], toSection: .between251and500kb)
        snapshot.appendItems(imageSections[3], toSection: .higherThan500kb)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.3)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 10
            section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 10)
            //section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
            section.supplementariesFollowContentInsets = false
            return section
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchVM.loadItems(term: searchText)
    }
}
