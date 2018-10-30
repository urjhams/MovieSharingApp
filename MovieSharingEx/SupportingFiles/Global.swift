//
//  Global.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 30.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import Foundation
import UIKit

/// Where holds the global functions
struct Global {
    /**
     Making an Image view with round corner and shadowed
     - Warning: require an UIView as the container of the Image for the shadow
     - Parameters:
        - imgView: the image view
        - container: the view that hold the image view
     */
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
    
    /**
     Send data to MovieDetailViewController and push it into the stack of Navigation controller's childs list
     - Parameters:
        - movie: the movieInfo object
        - thumbnail: the dowloaded image from the movieInfo object
        - navi: the Navigation controller that holding the current View controller
     */
    public static func changeToContent(of movie: MovieInfo, withThumbnail thumbnail: UIImage?, in navi: UINavigationController?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        if let destination = storyBoard.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailViewController {
            destination.movie = movie
            destination.thumbnail = thumbnail
            navi?.pushViewController(destination, animated: true)
        }
    }
    
    /**
     Show an alert controller with single message
     - Parameters:
        - content: the content of message
        - title: the title of the alert
        - vc: the view comtroller that present the alert
     */
    public static func showMessage(_ content: String, withTitle title: String, inside vc: UIViewController) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    /**
     Create a n UITableView from a xib file inside another container UIView with the frame & size clipped in the same size as the container.
     - Parameters:
     - tableView: The table view instance, could be optional because it will be initalized by the information about the container's size
     - view: The container UIView which the tableView is put inside
     - nib: The nib name string (from the xib file)
     - id: The reuse identifier for reuse cells inside the table view
     - delegate: the protocol of delegate for the table view
     - dataSource: the protocol of data source for the table view
     */
    public static func initTableView(_ tableView: inout UITableView?,inside view: UIView, fromCellNib nib: String, withCellIdentifier id: String, throughDelegate delegate: UITableViewDelegate, withDatasoruce dataSource: UITableViewDataSource) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.bounds.height), style: .plain)
        tableView!.delegate = delegate
        tableView!.dataSource = dataSource
        tableView!.backgroundColor = .white
        tableView!.separatorStyle = .none
        tableView!.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: id)
        view.addSubview(tableView!)
    }
}
