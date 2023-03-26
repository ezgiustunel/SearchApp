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

final class SearchImageModel: Hashable {
    var id = UUID()
    var image: UIImage
    var categoryType: ImageCategoryType
    
    init(image: UIImage, withCategoryType categoryType: ImageCategoryType) {
        self.image = image
        self.categoryType = categoryType
    }
    
    func hash(into hasher: inout Hasher) {
      // 2
      hasher.combine(id)
    }
    // 3
    static func == (lhs: SearchImageModel, rhs: SearchImageModel) -> Bool {
      lhs.id == rhs.id
    }
}
