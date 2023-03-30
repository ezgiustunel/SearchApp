//
//  ImageCVC.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 26.03.2023.
//

import UIKit

final class ImageCVC: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ImageCVC.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup
    func setData(imageModel: SearchList.ImageModel) {
        imageView.image = imageModel.imageData.image
        self.backgroundColor = UIColor.black.withAlphaComponent(0.05)
    }
    
    // MARK: - Add Views
    private func addViews() {
        backgroundColor = UIColor.clear
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    }
}
