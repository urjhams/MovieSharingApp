//
//  FavoriteViewController.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 16.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var naviItem: UINavigationItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var movieArray = [MovieInfo]() {
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    /// the list of movies which containt the search keyword
    var filteredMovies = [MovieInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigator(with: searchController)
        registerTableView(moviesTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieArray = Constants.Storage.favoriteMoviesList!
    }

}

// MARK: Search Control handling
extension FavoriteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContent(for: searchController.searchBar.text!)
    }
    
    private func setUpNavigator(with bar: UISearchController) {
        bar.searchResultsUpdater = self
        bar.obscuresBackgroundDuringPresentation = false
        bar.searchBar.placeholder = "Search"
        self.naviItem.searchController = bar
        
        // By default the navigation bar hides when presenting the
        // search interface.  Obviously we don't want this to happen if
        // our search bar is inside the navigation bar.
        searchController.hidesNavigationBarDuringPresentation = false
    }
}

// MARK: table view handling, data source & delegate
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// register the table view cell from the nib, set up the neccessary resources for the table ciew
    /// - parameters:
    ///     - table: the table view instance to initialize
    private func registerTableView(_ table: UITableView) {
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.delegate = self
        table.dataSource = self
        let nibName = Constants.nibName.movieTableCell
        let cellId = Constants.cellIdentifier.movieFavoriteTableCell
        table.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredMovies.count : movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = isFiltering() ? filteredMovies[indexPath.row] : movieArray[indexPath.row]
        let cellId = Constants.cellIdentifier.movieFavoriteTableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MovieTableViewCell
        cell.movie = movie
        do {
            let imageData = try Data(contentsOf: URL(string: movie.imageUrl)!)
            if let image = UIImage(data: imageData) {
                 cell.thumbnail = image
            }
        } catch {
            print(error.localizedDescription)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = isFiltering() ? filteredMovies[indexPath.row] : movieArray[indexPath.row]
        var img: UIImage?
        do {
            let imageData = try Data(contentsOf: URL(string: movie.imageUrl)!)
            if let image = UIImage(data: imageData) {
                img = image
            }
        } catch {
            print(error.localizedDescription)
        }
        Global.changeToContent(of: movie, withThumbnail: img, in: self.navigationController)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        let label = UILabel(frame: CGRect(x: 16, y: 5 , width: headerView.bounds.width - 32, height: 20))
        label.text = "Now"
        label.font = UIFont(name: "HelveticaNeue", size: 21)
        label.textColor = UIColor(white: 0.1, alpha: 0.7)
        headerView.addSubview(label)
        headerView.backgroundColor = .white
        return headerView
    }
}

// MARK: handling data of favorite table view and filter search view
extension FavoriteViewController {
    
    /// Get the current state of the search bar is empty or not
    private func SearchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Get the content of searching keyword through the filter function and set to filteredMovies variable
    private func filterContent(for text: String) {
        filteredMovies = movieArray.filter({ (movie) -> Bool in
            return movie.title.lowercased().contains(text.lowercased())
        })
        self.moviesTableView.reloadData()
    }
    
    /**
     Check if searching or not
     - Returns: the state of searching/ filtering
     */
    private func isFiltering() -> Bool {
        return searchController.isActive && !SearchBarIsEmpty()
    }
}
