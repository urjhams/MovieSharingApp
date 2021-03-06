//
//  MovieViewController.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var gridTableView: UITableView!
    @IBOutlet weak var listTableView: UITableView!

    
    /// the array that holds the MovieInfo objects
    ///
    /// Everytime this array is set, reload the tableview data, and the collection view in grid mode
    var moviesList: [MovieInfo]? {
        didSet {
            listTableView?.reloadData()
            gridTableView?.reloadData()
            if let cells = gridTableView?.visibleCells as? [MovieGridTableViewCell] {
                for cell in cells {
                    cell.horizontalListCollectionView.reloadData()
                }
            }
        }
    }
    
    /// The array that holds the dowloaded image, which is pair with the objects in movieList array
    var thumbnailList: [UIImage]? {
        didSet {
            gridTableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        self.segmentControl.addTarget(self,
                                      action: #selector(onSegmentIndexChange(_:)),
                                      for: .valueChanged)
        gridTableView?.isHidden = false
        listTableView?.isHidden = true
    }

}

// MARK: actions
extension MovieViewController {
    @objc private func onSegmentIndexChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gridTableView?.isHidden = false
            listTableView?.isHidden = true
        case 1:
            gridTableView?.isHidden = true
            listTableView?.isHidden = false
        default:
            break
        }
    }
}

// MARK: Initalizing the necessary content of the view controller's view
 extension MovieViewController {
    // create 2 tableview for grid & list
    private func prepareView() {
        Global.configTableView(&self.gridTableView,
                      fromCellNib: Constants.nibName.movieGridTableCell,
                      withCellIdentifier: Constants.cellIdentifier.movieGridTableCell,
                      throughDelegate: self,
                      withDatasoruce: self)
        
        Global.configTableView(&self.listTableView,
                      fromCellNib: Constants.nibName.movieTableCell,
                      withCellIdentifier: Constants.cellIdentifier.movieTableCell,
                      throughDelegate: self,
                      withDatasoruce: self)
    }
    
}

// MARK: tableview handling (Delegate & Datasource)
extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case listTableView:
            return moviesList?.count ?? 0
        case gridTableView:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
            case listTableView:
                let movie = moviesList![indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier.movieTableCell) as! MovieTableViewCell
                cell.movie = movie
                cell.thumbnail = thumbnailList?[indexPath.row]
                return cell
            case gridTableView:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier.movieGridTableCell) as! MovieGridTableViewCell
                cell.moviesList = self.moviesList ?? [MovieInfo]()
                cell.thumbnailList = self.thumbnailList
                cell.parrentInstance = self
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        let label = UILabel(frame: CGRect(x: 16, y: 5 , width: headerView.bounds.width - 32, height: 20))
        label.text = (section == 0) ? "Now" : "You may like"
        label.font = UIFont(name: "HelveticaNeue", size: 21)
        label.textColor = UIColor(white: 0.1, alpha: 0.7)
        headerView.addSubview(label)
        headerView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = moviesList![indexPath.row]
        let thumbnail = thumbnailList?[indexPath.row]
        Global.changeToContent(of: movie, withThumbnail: thumbnail, in: self.navigationController)

    }

}
