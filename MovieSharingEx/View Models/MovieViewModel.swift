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
