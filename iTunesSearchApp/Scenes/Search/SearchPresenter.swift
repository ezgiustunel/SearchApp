//
//  SearchPresenter.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 28.03.2023.
//

import UIKit

protocol SearchPresenterProtocol {
    var view: SearchViewProtocol? { get set }
    func cleanAllItems()
    func presentSearchData(imageModel: SearchList.ImageModel)
    func presentNoData()
    func presentLoading()
    func getImageWithSizeCategory(imageModel: SearchList.ImageModel) -> SearchList.ImageModel
    func findImageCategory(imageSize: Double) -> SearchList.ImageModel.SizeType
}

final class SearchPresenter: SearchPresenterProtocol {
    var view: SearchViewProtocol?
    var viewModel = SearchList.ImageModel.ViewModel(allImages: [])
    
    func presentSearchData(imageModel: SearchList.ImageModel) {
        let image = getImageWithSizeCategory(imageModel: imageModel)
        viewModel.allImages.append(image)
        view?.showData(viewModel: viewModel)
    }
    
    func presentNoData() {
        view?.showNoData()
    }
    
    func presentLoading() {
        view?.showEmpty()
    }
    
    func cleanAllItems() {
        viewModel.allImages.removeAll()
    }
    
    func getImageWithSizeCategory(imageModel: SearchList.ImageModel) -> SearchList.ImageModel {
        let imageCategory = findImageCategory(imageSize: imageModel.imageData.image.imageSize)
        return SearchList.ImageModel(imageData: imageModel.imageData, categoryType: imageCategory)
    }
    
    func findImageCategory(imageSize: Double) -> SearchList.ImageModel.SizeType {
        if imageSize <= 100 {
            return .lessOrEqual100kb
        } else if imageSize > 100 && imageSize <= 250 {
            return .between101and250kb
        } else if imageSize > 250 && imageSize <= 500 {
            return .between251and500kb
        } else {
            return .higherThan500kb
        }
    }
}
