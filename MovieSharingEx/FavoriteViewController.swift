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
    let searchBar = UISearchController(searchResultsController: nil)
    
    var movieArray = [MovieInfo]() {
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigator(with: searchBar)
        registerTableView(moviesTableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        movieArray = favoriteList()
    }

}

extension FavoriteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
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
        return movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movieArray[indexPath.row]
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
        let movie = movieArray[indexPath.row]
        var img: UIImage?
        do {
            let imageData = try Data(contentsOf: URL(string: movie.imageUrl)!)
            if let image = UIImage(data: imageData) {
                img = image
            }
        } catch {
            print(error.localizedDescription)
        }
        changeToContent(of: self.movieArray[indexPath.row], withThumbnail: img)
    }
    
    private func registerTableView(_ table: UITableView) {
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.delegate = self
        table.dataSource = self
        let nibName = Constants.nibName.movieTableCell
        table.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier.movieFavoriteTableCell)
    }
    
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
            if var stack = self.navigationController?.viewControllers {
                stack.append(destination)
            }
            destination.movie = movie
            destination.thumbnail = thumbnail
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

}
