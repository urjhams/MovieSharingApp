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
    
    var liked = false {
        didSet {
            setUpNavigationBar()
        }
    }
    var movie: MovieInfo?
    var thumbnail: UIImage?
    
    var likeBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfomation(of: movie)
        updateImage(from: thumbnail)
        setUpNavigationBar()
        setUpFrames()
    }
    
}

extension MovieDetailViewController {
    private func updateInfomation(of movie: MovieInfo?) {
        titleLabel.text = movie?.title ?? ""
        infoLabel.text = "3,292 People watching \nAction, Adventure, Fantasy"
        descriptionLabel.text = movie?.description ?? ""
        liked = isLiked()
    }
    
    private func updateImage(from img: UIImage?) {
        if let img = img {
            coverImageView.image = img
            thumbnailView.image = img
        }
    }
    
    private func setUpNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = movie?.title
        let likeImage = liked ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "favorite_disable")
        likeBarButton = Constants.addButton(withImage: likeImage, toNavi: self.navigationController, target: self, withAction: #selector(clickLike(_:)))
    }
    
    private func setUpFrames() {
        Constants.setShadowBorderedImage(fromImgView: thumbnailView, withContainer: containerView)
        coverImageView.contentMode = .scaleAspectFill
        infoLabel.setLineSpacing(lineSpacing: 8.0)
    }
    
    private func isLiked() -> Bool {
        if let favorites = Constants.Storage.favoriteIdList as? Data {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Array.self, from: favorites) as [MovieInfo] {
                for movie in decoded {
                    if movie.id == self.movie!.id {
                        return true
                    }
                }
            }
        }
        return false
    }
    
}

extension MovieDetailViewController {
    
    @objc private func clickLike(_ sender: UIBarButtonItem) {
        if liked {
            guard let objects = Constants.Storage.favoriteIdList as? Data else {
                print("no favorite object saved(nil) but still liked already?")
                return
            }
            let decoder = JSONDecoder()
            if var decoded = try? decoder.decode(Array.self, from: objects) as [MovieInfo] {
                for index in 0...decoded.count-1 {
                    if decoded[index].id == self.movie!.id {
                        decoded.remove(at: index)
                        encodeData(decoded, andSaveToStorageWithKey: Constants.Storage.idKey)
                    }
                }
            } else {
                return
            }
        } else {
            if let objects = Constants.Storage.favoriteIdList as? Data {
                checkAndSaveArrayData(objects, andSaveToStorageWithKey: Constants.Storage.idKey)
            } else {
                let objects = [self.movie!]
                encodeData(objects, andSaveToStorageWithKey: Constants.Storage.idKey)
            }
        }
        
        liked = !liked
    }
    
    private func getFavoriteList() -> Data? {
        return Data()
    }
    
    private func checkAndSaveArrayData(_ data: Data, andSaveToStorageWithKey key: String) {
        let decoder = JSONDecoder()
        if var decoded = try? decoder.decode(Array.self, from: data) as [MovieInfo] {
            for movie in decoded {
                if movie.id == self.movie!.id {
                    return
                } else {
                    decoded.append(self.movie!)
                    encodeData(decoded, andSaveToStorageWithKey: key)
                }
            }
        }
    }
    
    private func encodeData(_ movies: [MovieInfo], andSaveToStorageWithKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(movies) {
            UserDefaults.standard.set(encoded, forKey: key)
            Constants.Storage.favoriteIdList = encoded
        }
    }
    
}

