//
//  PhotoCell.swift
//  UnsplashKraken
//
//  Created by Toriq Wahid Syaefullah on 30/11/20.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.startAnimating()
        imageView.layer.cornerRadius = 16
    }

    class var reuseIdentifier: String {
        return "PhotoCell"
    }
    class var nibName: String {
        return "PhotoCell"
    }
    func configureCell(image: UIImage) {
        self.imageView.image = image
    }

}
