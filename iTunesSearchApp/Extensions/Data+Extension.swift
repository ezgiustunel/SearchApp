//
//  Data+Extension.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 29.03.2023.
//

import Foundation

import UIKit

extension Data {
    var image: UIImage {
        return UIImage(data: self) ?? UIImage()
    }
}
