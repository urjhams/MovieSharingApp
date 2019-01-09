//
//  MovieViewModel.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 09.01.19.
//  Copyright © 2019 urjhams. All rights reserved.
//

import UIKit

public final class MovieViewModel {
    // instance
    public let movie: MovieInfo
    
    // variables for assign
    public let title: String
    public let info: String
    public let description: String
    public let coverImg: UIImage?
    public let thumbnailImg: UIImage?
    private let delegate: MovieDetailDelegate?
    
    public var like = false {
        didSet {
            if let delegate = self.delegate {
                delegate.setLike(image: like ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "favorite_disable"))
            }
        }
    }
    
    // object life cycle
    init(movie: MovieInfo, cover: UIImage?, thumbnail: UIImage?, delegate: MovieDetailDelegate?) {
        self.movie = movie
        title = movie.title
        description = movie.description
        info = "3,292 People watching \nAction, Adventure, Fantasy"
        self.coverImg = cover
        self.thumbnailImg = thumbnail
        self.like = Global.didLike(movie: movie)
        self.delegate = delegate
    }
}

// MARK: handling save action and process
extension MovieViewModel {
    public func likeProcess() {
        if self.like {
            if !removeTheMovie(self.movie) {
                if let delegate = self.delegate {
                    delegate.showMess(mess: "Oops, something happen", withTitle: "Removed")
                }
            }
        }
        else {
            if !saveTheMovie(self.movie) {
                if let delegate = self.delegate {
                    delegate.showMess(mess: "Oops, something happen", withTitle: "Removed")
                }
            }
        }
        self.like = !self.like
    }
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
