//
//  MovieCollectionViewCell.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 17.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbailImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbailImageView.layer.cornerRadius = 6
        self.thumbailImageView.layer.masksToBounds = true
    }

}
