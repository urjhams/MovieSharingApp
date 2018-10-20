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
    let searchController = UISearchController(searchResultsController: nil)
    
    var movieArray = [MovieInfo]() {
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    var filteredMovies = [MovieInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigator(with: searchController)
        registerTableView(moviesTableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieArray = favoriteList()
    }

}

extension FavoriteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContent(for: searchController.searchBar.text!)
    }
    
    private func setUpNavigator(with bar: UISearchController) {
        bar.searchResultsUpdater = self
        bar.obscuresBackgroundDuringPresentation = false
        bar.searchBar.placeholder = "Search"
        navigationItem.searchController = bar
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredMovies.count : movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = isFiltering() ? filteredMovies[indexPath.row] : movieArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier.movieFavoriteTableCell) as! MovieTableViewCell
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
        changeToContent(of: movie, withThumbnail: img)
    }
    
    private func registerTableView(_ table: UITableView) {
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.delegate = self
        table.dataSource = self
        let nibName = Constants.nibName.movieTableCell
        table.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier.movieFavoriteTableCell)
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

extension FavoriteViewController {
    
    private func favoriteList() -> [MovieInfo] {
        guard let objects = Constants.Storage.favoriteIdList as? Data else {
            return [MovieInfo]()
        }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(Array.self, from: objects) as [MovieInfo] {
            return decoded
        }
        return [MovieInfo]()
    }
    
    private func changeToContent(of movie: MovieInfo, withThumbnail thumbnail: UIImage?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        if let destination = storyBoard.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailViewController {
            destination.movie = movie
            destination.thumbnail = thumbnail
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    private func SearchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContent(for text: String, scope: String = "All") {
        filteredMovies = movieArray.filter({ (movie) -> Bool in
            return movie.title.lowercased().contains(text.lowercased())
        })
        
        self.moviesTableView.reloadData()
    }

    private func isFiltering() -> Bool {
        return searchController.isActive && !SearchBarIsEmpty()
    }
}
