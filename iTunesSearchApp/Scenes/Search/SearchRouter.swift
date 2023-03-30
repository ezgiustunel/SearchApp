//
//  SearchRouter.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 28.03.2023.
//

import Foundation
import UIKit

protocol SearchRouterProtocol {
    var view: HomeVC? { get }
    static func createSearchScene() -> SearchRouterProtocol
    func navigatePreviewPage(image: UIImage)
}

final class SearchRouter: SearchRouterProtocol {
    weak var view: HomeVC?

    func navigatePreviewPage(image: UIImage) {
        let vc = ImagePreviewVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.image = image
        self.view?.present(vc, animated: true)
    }
    
    static func createSearchScene() -> SearchRouterProtocol {
        let router = SearchRouter()
        let view = HomeVC()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        
        router.view = view
        
        view.interactor = interactor
        view.router = router
        
        interactor.presenter = presenter
        
        presenter.view = view
        
        return router
    }
}
