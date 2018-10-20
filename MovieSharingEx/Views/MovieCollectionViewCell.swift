//
//  MovieCollectionViewCell.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 17.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    var movie: MovieInfo? {
        didSet {
            movieNameLabel.text = movie?.title ?? ""
        }
    }
    
    var thumbnail: UIImage? {
        didSet {
            if let img = thumbnail {
                thumbnailImageView.image = img
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Constants.setShadowBorderedImage(fromImgView: thumbnailImageView, withContainer: containerView)
    }

}
