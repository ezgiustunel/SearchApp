//
//  ImageHelper.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import UIKit


enum ImageSection: CaseIterable {
    case lessOrEqual100kb
    case between101and250kb
    case between251and500kb
    case higherThan500kb
}

final class ImageHelper {
    static var shared = ImageHelper()
    
    var lessOrEqual100kbList = [SearchImageModel]()
    var between101and250kbList = [SearchImageModel]()
    var between251and500kbList = [SearchImageModel]()
    var higherThan500kbList = [SearchImageModel]()
    var imageSectionData = [[SearchImageModel]]()
    
    func getImageSections(image: UIImage) {
        let image = getImageWithSizeCategory(image: image)
        
        switch image.categoryType {
        case .lessOrEqual100kb:
            lessOrEqual100kbList.append(image)
        case .between101and250kb:
            between101and250kbList.append(image)
        case .between251and500kb:
            between251and500kbList.append(image)
        case .higherThan500kb:
            higherThan500kbList.append(image)
        }
        
        imageSectionData = [lessOrEqual100kbList, between101and250kbList, between251and500kbList, higherThan500kbList]
        NotificationCenter.default.post(name: NSNotification.Name.ReloadImageCollectionView, object: nil)
    }
    
    func cleanAllItems() {
        imageSectionData.removeAll()
        lessOrEqual100kbList.removeAll()
        between101and250kbList.removeAll()
        between251and500kbList.removeAll()
        higherThan500kbList.removeAll()
    }
    
    private func getImageWithSizeCategory(image: UIImage) -> SearchImageModel {
        let imageCategory = findImageCategory(imageSize: image.imageSize)
        return SearchImageModel(image: image, withCategoryType: imageCategory)
    }
    
    private func findImageCategory(imageSize: Double) -> ImageCategoryType {
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
