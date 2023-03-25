//
//  URL+Extension.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

extension URL {
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: Double {
        let sizeInBytes = attributes?[.size] as? UInt64 ?? UInt64(0)
        return Double(sizeInBytes / 1024)
    }
}
