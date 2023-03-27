//
//  HomeVC.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 24.03.2023.
//

import UIKit

final class HomeVC: UIViewController {
    private var collectionView: UICollectionView?
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
        //SearchBar
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.delegate = self
        let searchBar = searchController.searchBar
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraint = NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .leading, multiplier: 1, constant: 20)
        let bottomConstraint = NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .bottom, multiplier: 1, constant: 1)
        let topConstraint = NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .top, multiplier: 1, constant: 1)
        let widthConstraint = NSLayoutConstraint(item: searchBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.size.width - 40)
        navigationController?.navigationBar.addConstraints([leftConstraint, bottomConstraint, topConstraint, widthConstraint])
        
        //CollectionView
        collectionView = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.size.width, height: view.frame.size.height)), collectionViewLayout: createLayout())
        collectionView?.bounces = false
        collectionView?.delegate = self
        collectionView?.register(ImageCVC.self, forCellWithReuseIdentifier: ImageCVC.reuseIdentifier)
        
        view.addSubview(collectionView ?? UICollectionView())
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    
    private func setupData() {
        searchVM.loadItems(term: "apple")
        dataSource = configureDataSource()
    }
    
    // MARK: - Layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.3)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
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
    
    // MARK: - CollectionView Diffable DataSource
    private func configureDataSource() -> UICollectionViewDiffableDataSource<ImageSection, SearchImageModel> {
        let dataSource = UICollectionViewDiffableDataSource<ImageSection, SearchImageModel>(collectionView: collectionView ?? UICollectionView()) { (collectionView, indexPath, imageModel) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVC.reuseIdentifier, for: indexPath) as! ImageCVC
            cell.setData(imageModel: imageModel)
            return cell
        }
        return dataSource
    }
    
    // MARK: - Notification
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
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageModel = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = ImagePreviewVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.image = imageModel.image
        present(vc, animated: true)
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchVM.loadItems(term: searchText)
    }
}
