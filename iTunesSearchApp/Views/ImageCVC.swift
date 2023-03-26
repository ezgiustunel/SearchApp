//
//  ImageCVC.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 26.03.2023.
//

import UIKit

final class ImageCVC: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(imageModel: SearchImageModel) {
        imageView.image = imageModel.image
    }
}
