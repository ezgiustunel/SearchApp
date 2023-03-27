//
//  ImagePreviewVC.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 27.03.2023.
//

import UIKit

final class ImagePreviewVC: UIViewController {
    private var imageView: UIImageView?
    var image: UIImage?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        self.dismissViewWhenTappedAround()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        //ImageView
        imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100)))
        guard let imageView = imageView else { return }
        guard let image = image else { return }
        
        imageView.image = image
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 400)
        let xConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraints([widthConstraint, heightConstraint, xConstraint, yConstraint])
    }
}

extension UIViewController {
    func dismissViewWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: false)
    }
}
