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
    
    var likeBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfomation(of: movie)
        updateImage(from: thumbnail)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        setUpFrames()
    }
    
}

extension MovieDetailViewController {
    private func updateInfomation(of movie: MovieInfo?) {
        titleLabel.text = movie?.title ?? ""
        infoLabel.text = "3,292 People watching \nAction, Adventure, Fantasy"
        descriptionLabel.text = movie?.description ?? ""
    }
    
    private func updateImage(from img: UIImage?) {
        if let img = img {
            coverImageView.image = img
            thumbnailView.image = img
        }
    }
    
    private func setUpNavigationBar() {
        self.naviItem.title = movie?.title
        let likeImage =  #imageLiteral(resourceName: "favorite_disable")
        self.naviItem.rightBarButtonItem = UIBarButtonItem(image: likeImage, style: .plain, target: self, action: #selector(clickLike(_:)))
    }
    
    private func setUpFrames() {
        Constants.setShadowBorderedImage(fromImgView: thumbnailView, withContainer: containerView)
        coverImageView.contentMode = .scaleAspectFill
        infoLabel.setLineSpacing(lineSpacing: 8.0)
    }
    
}

extension MovieDetailViewController {
    
    @objc private func clickLike(_ sender: UIBarButtonItem) {
        if let objects = Constants.Storage.favoriteIdList as? Data {
            checkAndSaveArrayData(objects, andSaveToStorageWithKey: Constants.Storage.idKey)
        } else {
            let objects = [self.movie!]
            encodeData(objects, andSaveToStorageWithKey: Constants.Storage.idKey)
        }
        Constants.showMessage("Save item successful", withTitle: "Saved", inside: self)
    }
    
    private func getFavoriteList() -> Data? {
        return Data()
    }
    
    private func checkAndSaveArrayData(_ data: Data, andSaveToStorageWithKey key: String) {
        let decoder = JSONDecoder()
        if var decoded = try? decoder.decode(Array.self, from: data) as [MovieInfo] {
            var existed = false
            for movie in decoded {
                if movie.id == self.movie?.id {
                    existed = true
                }
            }
            if !existed {
                decoded.append(self.movie!)
                encodeData(decoded, andSaveToStorageWithKey: key)
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

