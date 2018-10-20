//
//  Constants.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Storage {
        static let idKey = "favorite video id"
        static var favoriteIdList = UserDefaults.standard.value(forKey: idKey)
    }
    
    
    struct YoutubeApi {
        
        static let baseUrl = "https://www.googleapis.com/youtube/v3/activities?part=contentDetails%2C+snippet&channelId=UClgRkhTL3_hImCAmdLfDE4g&maxResults=10&key=\(key)"
        
        static let key = "AIzaSyD5PSKE5l2VP7EmsCrVvaMfQXu8BS5_PcE"
        
        struct NetworkStatusCode {
            static let ok = 200
            static let badRequest = 400
            static let forbidden = 403
            static let notFound = 404
        }
    }
    
    struct MessageStrings {
        static let loading = "Loading movies"
    }
    
    struct nibName {
        static let movieCollectionCell = "MovieCollectionViewCell"
        static let movieTableCell = "MovieTableViewCell"
        static let movieGridTableCell = "MovieGridTableViewCell"
    }
    
    struct cellIdentifier {
        static let movieCollectionCell = "movieCollectionCell"
        static let movieTableCell = "movieTableCell"
        static let movieGridTableCell = "movieGridTableCell"
        static let movieFavoriteTableCell = "movieFavoriteTableCell"
    }
    
    static func setShadowBorderedImage(fromImgView imgView: UIImageView, withContainer container: UIView) {
        
        container.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 8)
        container.layer.shadowOpacity = 0.5
        container.layer.shadowRadius = 6.0
        container.backgroundColor = .clear
        
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 6
        imgView.layer.masksToBounds = true
    }
    
    public static func changeToContent(of movie: MovieInfo, withThumbnail thumbnail: UIImage?, in navi: UINavigationController?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        if let destination = storyBoard.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailViewController {
            if var stack = navi?.viewControllers {
                stack.append(destination)
            }
            destination.movie = movie
            destination.thumbnail = thumbnail
            navi?.pushViewController(destination, animated: true)
        }
    }
    
    public static func showMessage(_ content: String, withTitle title: String, inside vc: UIViewController) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}




