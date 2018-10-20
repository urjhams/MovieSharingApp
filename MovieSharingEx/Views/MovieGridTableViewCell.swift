//
//  MovieGridTableViewCell.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 18.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

class MovieGridTableViewCell: UITableViewCell {
    
    @IBOutlet weak var horizontalListCollectionView: UICollectionView!
    
    var moviesList = [MovieInfo]() {
        didSet {
            horizontalListCollectionView.reloadData()
        }
    }
    var thumbnailList: [UIImage]?
    
    var parrentInstance: MovieViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        horizontalListCollectionView.delegate = self
        horizontalListCollectionView.dataSource = self
        
        if let layout = horizontalListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 8
            layout.itemSize = CGSize(width: 240 , height: 420)
        }
        horizontalListCollectionView.backgroundColor = .white
        horizontalListCollectionView.showsHorizontalScrollIndicator = false
        horizontalListCollectionView.register(UINib(nibName: Constants.nibName.movieCollectionCell,
                                                    bundle: nil),
                                              forCellWithReuseIdentifier: Constants.cellIdentifier.movieCollectionCell)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension MovieGridTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = moviesList[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier.movieCollectionCell, for: indexPath) as! MovieCollectionViewCell
        
        cell.movie = movie
        cell.thumbnail = thumbnailList?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = moviesList[indexPath.row]
        let thumbnail = thumbnailList?[indexPath.item]
        if let parrent = parrentInstance {
            parrent.changeToContent(of: movie, withThumbnail: thumbnail)
        }
    }
    
}

