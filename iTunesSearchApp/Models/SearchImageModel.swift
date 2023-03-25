//
//  SearchImageModel.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import UIKit

enum ImageCategoryType {
    case lessOrEqual100kb
    case between101and250kb
    case between251and500kb
    case higherThan500kb
}

struct SearchImageModel {
    var image: UIImage
    var categoryType: ImageCategoryType
    
    init(image: UIImage, withCategoryType categoryType: ImageCategoryType) {
        self.image = image
        self.categoryType = categoryType
    }
}
