//
//  ImageHelper.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import UIKit

enum ImageSection {
    case lessOrEqual100kb([SearchImageModel])
    case between101and250kb([SearchImageModel])
    case between251and500kb([SearchImageModel])
    case higherThan500kb([SearchImageModel])
    
    var items: [SearchImageModel] {
        switch self {
        case .lessOrEqual100kb(let items),
                .between101and250kb(let items),
                .between251and500kb(let items),
                .higherThan500kb(let items):
            return items
        }
    }
    
    var count: Int {
        return items.count
    }
    
    var title: String {
        switch self {
        case .lessOrEqual100kb:
            return "lessOrEqual100kb"
        case .between101and250kb:
            return "between101and250kb"
        case .between251and500kb:
            return "between251and500kb"
        case .higherThan500kb:
            return "higherThan500kb"
        }
    }
}

struct ImageHelper {
    
    static func getImageSections(images: [UIImage]) -> [ImageSection] {
        var images = getAllImagesWithSizeCategories(images: images)

        var lessOrEqual100kbList = [SearchImageModel]()
        var between101and250kbList = [SearchImageModel]()
        var between251and500kbList = [SearchImageModel]()
        var higherThan500kbList = [SearchImageModel]()
        
        for image in images {
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
        }
        
        var imageSectionData: [ImageSection] {
            [ImageSection.lessOrEqual100kb(lessOrEqual100kbList),
             ImageSection.between101and250kb(between101and250kbList),
             ImageSection.between251and500kb(between251and500kbList),
             ImageSection.higherThan500kb(higherThan500kbList)]
        }
        
        return imageSectionData
    }
    
    private static func getAllImagesWithSizeCategories(images:[UIImage]) -> [SearchImageModel] {
        var imagesWithCategories = [SearchImageModel]()
        
        for image in images {
            let imageCategory = findImageCategory(imageSize: image.imageSize)
            imagesWithCategories.append(SearchImageModel(image: image, withCategoryType: imageCategory))
        }
        
        return imagesWithCategories
    }
    
    private static func findImageCategory(imageSize: Double) -> ImageCategoryType {
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
