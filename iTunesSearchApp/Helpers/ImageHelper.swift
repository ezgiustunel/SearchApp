//
//  ImageHelper.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import UIKit

struct ImageHelper {
    static func getAllImagesWithSizeCategories(images:[UIImage]) -> [SearchImageModel] {
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
