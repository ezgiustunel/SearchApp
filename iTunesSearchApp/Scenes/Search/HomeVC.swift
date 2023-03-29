//
//  HomeVC.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 24.03.2023.
//

import UIKit

protocol SearchViewProtocol {
    var router: SearchRouterProtocol? { get set }
    var interactor: SearchInteractorProtocol? { get set }
    func showData(viewModel: SearchList.ImageModel.ViewModel)
    func showNoData()
    func showEmpty()
}

final class HomeVC: UIViewController {
    private var collectionView: UICollectionView?
    private var noDataView: UIView = UIView()
    private var noDataLabel: UILabel = UILabel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()
    
    typealias DataSource = UICollectionViewDiffableDataSource<SearchList.ImageModel.SizeType, SearchList.ImageModel>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SearchList.ImageModel.SizeType, SearchList.ImageModel>
    
    var router: SearchRouterProtocol?
    var interactor: SearchInteractorProtocol?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.overrideUserInterfaceStyle = .light
        self.view.backgroundColor = UIColor.white
        //SearchBar
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.delegate = self
        let searchBar = searchController.searchBar
        searchBar.tintColor = UIColor.white
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
        
        //No Data View
        noDataView.backgroundColor = UIColor.clear
        //noDataView.isHidden = true
        view.addSubview(noDataView)
        noDataView.translatesAutoresizingMaskIntoConstraints = false

        let noDataViewHorizontalConstraint = NSLayoutConstraint(item: noDataView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let noDataViewVerticalConstraint = NSLayoutConstraint(item: noDataView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let noDataViewWidthConstraint = NSLayoutConstraint(item: noDataView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.size.width)
        let NoDataViewHeightConstraint = NSLayoutConstraint(item: noDataView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        
        view.addConstraints([noDataViewHorizontalConstraint, noDataViewVerticalConstraint, noDataViewWidthConstraint, NoDataViewHeightConstraint])
        
        noDataLabel.text = "Search something..."
        noDataLabel.font = noDataLabel.font.withSize(25)
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = UIColor.darkGray
        noDataView.addSubview(noDataLabel)
        
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        let noDataLabelHorizontalConstraint = NSLayoutConstraint(item: noDataLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: noDataView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let noDataLabelVerticalConstraint = NSLayoutConstraint(item: noDataLabel, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: noDataView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let noDataLabelWidthConstraint = NSLayoutConstraint(item: noDataLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.size.width)
        let NoDataLabelHeightConstraint = NSLayoutConstraint(item: noDataLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        noDataView.addConstraints([noDataLabelHorizontalConstraint, noDataLabelVerticalConstraint, noDataLabelWidthConstraint, NoDataLabelHeightConstraint])
    }
    
    private func setupData() {
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
            section.supplementariesFollowContentInsets = false
            return section
        }
    }
    
    // MARK: - CollectionView Diffable DataSource
    private func configureDataSource() -> UICollectionViewDiffableDataSource<SearchList.ImageModel.SizeType, SearchList.ImageModel> {
        let dataSource = UICollectionViewDiffableDataSource<SearchList.ImageModel.SizeType, SearchList.ImageModel>(collectionView: collectionView ?? UICollectionView()) { (collectionView, indexPath, imageModel) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVC.reuseIdentifier, for: indexPath) as! ImageCVC
            cell.setData(imageModel: imageModel)
            return cell
        }
        return dataSource
    }
    
    func updateDataSource(viewModel: SearchList.ImageModel.ViewModel) {
        snapshot = DataSourceSnapshot()
        
        for sizeType in SearchList.ImageModel.SizeType.allCases {
            let images = viewModel.allImages.filter { $0.categoryType == sizeType }
            if (images.count == 0) { continue }
            snapshot.appendSections([sizeType])
            snapshot.appendItems(images, toSection: sizeType)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageModel = dataSource.itemIdentifier(for: indexPath) else { return }
        router?.navigatePreviewPage(image: imageModel.imageData.image)
    }
}

// MARK: - UISearchBarDelegate
extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchController.isActive = false
        searchController.searchBar.text = searchText
        interactor?.filterSearchWith(term: searchText)
    }
}

// MARK: - SearchViewProtocol
extension HomeVC: SearchViewProtocol {
    func showNoData() {
        DispatchQueue.main.async {
            self.noDataLabel.text = "No Search Results!"
            self.collectionView?.isHidden = true
            self.noDataView.isHidden = false
        }
    }
    
    func showData(viewModel: SearchList.ImageModel.ViewModel) {
        DispatchQueue.main.async {
            self.noDataView.isHidden = true
            self.collectionView?.isHidden = false
        }
        updateDataSource(viewModel: viewModel)
    }
    
    func showEmpty() {
        DispatchQueue.main.async {
            self.noDataView.isHidden = true
            self.collectionView?.isHidden = true
        }
    }
}
