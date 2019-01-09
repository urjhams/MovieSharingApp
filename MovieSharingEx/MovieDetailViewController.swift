//
//  MovieDetailViewController.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 19.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

public protocol MovieDetailDelegate {
    func setLike(image: UIImage)
}
class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var naviItem: UINavigationItem!
    
    var movieViewModel: MovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfomation(of: movieViewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieViewModel.like = Global.didLike(movie: movieViewModel.movie)
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
    private func updateInfomation(of movie: MovieViewModel) {
        titleLabel.text = movie.title
        infoLabel.text = movie.info
        descriptionLabel.text = movie.description
        coverImageView.image = movie.coverImg
        thumbnailView.image = movie.thumbnailImg
        self.naviItem.title = movieViewModel.title
    }
    
    /// Set up the neccessary UI & framing content
    private func setUpFrames() {
        Global.setShadowBorderedImage(fromImgView: thumbnailView, withContainer: containerView)
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true
        infoLabel.setLineSpacing(lineSpacing: 8.0)
    }
}

extension MovieDetailViewController {
    @objc private func clickLike(_ sender: UIBarButtonItem) {
        // now it should had the movie object already
        if movieViewModel.like {
            if !Global.removeTheMovie(movieViewModel.movie) {
                Global.showMessage("Oops, something happen", withTitle: "Removed", inside: self)
            }
        } else {
            if !Global.saveTheMovie(movieViewModel.movie) {
                Global.showMessage("Oops, something happen", withTitle: "Removed", inside: self)
            }
        }
        movieViewModel.like = !movieViewModel.like
    }
}

extension MovieDetailViewController: MovieDetailDelegate {
    /// Set the image of like button on the navigation bar
    internal func setLike(image: UIImage) {
        self.naviItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(clickLike(_:)))
    }
}
