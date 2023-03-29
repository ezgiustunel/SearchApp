//
//  SearchModel.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation


enum SearchList {
    struct ImageModel: Hashable {
        var id = UUID ()
        var imageData: Data
        var categoryType: SizeType
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
            lhs.id == rhs.id
        }
        
        enum SizeType: CaseIterable {
            case lessOrEqual100kb
            case between101and250kb
            case between251and500kb
            case higherThan500kb
        }
        
        struct ViewModel {
            var allImages: [ImageModel]
            
        }
    }
}
