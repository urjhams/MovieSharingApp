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
        self.liked = Global.didLike(movie: movie!)
        updateInfomation(of: movie)
        updateImage(from: thumbnail)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if let objects = Constants.Storage.favoriteDataList as? Data {
            checkMoviesArrayData(objects, andSaveToStorageWithKey: Constants.Storage.idKey)
        } else {
            let objects = [self.movie!]
            Global.encodeMoviesData(objects, andSaveToStorageWithKey: Constants.Storage.idKey, completion: saveFavoriteListIntoLiveArray)
        }
    }
}

// MARK: Saving process - UserDefault
extension MovieDetailViewController {
    /**
     Check if data exist and save using User default
     - Parameters:
        - data: the data need to save
        - key: the key value for indicate with User default
     */
    private func checkMoviesArrayData(_ data: Data, andSaveToStorageWithKey key: String) {
        let decoder = JSONDecoder()
        if var decoded = try? decoder.decode(Array.self, from: data) as [MovieInfo] {
            var existed = false
            for movie in decoded {
                if movie == self.movie {
                    existed = true
                }
            }
            if !existed {
                decoded.append(self.movie!)
                Global.encodeMoviesData(decoded, andSaveToStorageWithKey: key, completion: saveFavoriteListIntoLiveArray)
            }
        }
    }
    
    private func saveFavoriteListIntoLiveArray() {
        // Save to the seperate array of the object can increase peformance in favorite list
        // since don't have to decode everytime the screen appearing
        if var _ = Constants.Storage.favoriteMoviesList {
            Constants.Storage.favoriteMoviesList!.append(self.movie!)
        } else {
            Constants.Storage.favoriteMoviesList = [self.movie!]
        }
        Global.showMessage("Save item successful", withTitle: "Saved", inside: self)
    }
}

