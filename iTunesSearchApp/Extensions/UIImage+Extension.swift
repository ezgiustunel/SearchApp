//
//  UIImage+Extension.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import UIKit

extension UIImage {
    var imageSize: Double {
        let imgData = NSData(data: self.jpegData(compressionQuality: 1)!)
        let imageSize: Int = imgData.count
        print("EZGI in KB: %f ", Double(imageSize) / 1000.0)
        return Double(imageSize) / 1000.0
    }
}
