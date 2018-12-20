//
//  MovieDetailViewController.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 19.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var naviItem: UINavigationItem!
    
    var movie: MovieInfo?
    var thumbnail: UIImage?
    var liked = false {
        didSet {
            setLike(image: liked ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "favorite_disable"))
        }
    }
    
    var likeBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfomation(of: movie)
        updateImage(from: thumbnail)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.liked = Global.didLike(movie: movie!)
        setUpNavigationBar()
        setUpFrames()
    }
    
}

// MARK: Data & UI handling
extension MovieDetailViewController {
    /**
     Set information from the sent movie object
     - Parameters:
        - movie: The MovieInfo object which sent by previous view controller
     */
    private func updateInfomation(of movie: MovieInfo?) {
        titleLabel.text = movie?.title ?? ""
        infoLabel.text = "3,292 People watching \nAction, Adventure, Fantasy"
        descriptionLabel.text = movie?.description ?? ""
    }
    /**
     Set cover image from the sent image
     - Parameters:
        - img: The image which sent by previous view controller
     */
    private func updateImage(from img: UIImage?) {
        if let img = img {
            coverImageView.image = img
            thumbnailView.image = img
        }
    }
    
    /// Perpare the navigation bar with the title of the movie & add a favorite button on the right
    private func setUpNavigationBar() {
        self.naviItem.title = movie?.title
    }
    
    /// Set the image of like button on the navigation bar
    private func setLike(image: UIImage) {
        self.naviItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(clickLike(_:)))
    }
    
    /// Set up the neccessary UI & framing content
    private func setUpFrames() {
        Global.setShadowBorderedImage(fromImgView: thumbnailView, withContainer: containerView)
        coverImageView.contentMode = .scaleAspectFill
        infoLabel.setLineSpacing(lineSpacing: 8.0)
    }
    
}

// MARK: actions
extension MovieDetailViewController {
    @objc private func clickLike(_ sender: UIBarButtonItem) {
        // now it should had the movie object already
        if self.liked {
            if !removeTheMovie(self.movie!) {
                Global.showMessage("Oops, something happen",
                                   withTitle: "Removed", inside: self)
            }
            
        } else {
            if !saveTheMovie(self.movie!) {
                Global.showMessage("Oops, something happen",
                                   withTitle: "Removed", inside: self)
            }
        }
        self.liked = !self.liked
    }
}

// MARK: Saving process - UserDefault
extension MovieDetailViewController {
    private func saveTheMovie(_ movie: MovieInfo) -> Bool {
        if Constants.Storage.favoriteDataList.contains(movie) { return false }
        Constants.Storage.favoriteDataList.append(movie)
        return true
    }
    
    
    private func removeTheMovie(_ movie: MovieInfo) -> Bool {
        for index in 0..<Constants.Storage.favoriteDataList.count {
            if movie == Constants.Storage.favoriteDataList[index] {
                Constants.Storage.favoriteDataList.remove(at: index)
                return true
            }
        }
        return false
    }
}

