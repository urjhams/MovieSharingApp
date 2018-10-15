//
//  TabBarViewController.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

// MARK: overiding functions & variable declare
class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingMovie(from: Constants.YoutubeApi.baseUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
}

// MARK: custom functions
extension TabBarViewController {
    
    /**
     Load the movie list based on the url string
     - Parameters:
        - urlString: the string includes the API url
     */
    private func loadingMovie(from urlString: String) {
        // loading screen initialize
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        loadingView.backgroundColor = .white
        self.createdLoadingIndicator(in: loadingView, content: Constants.MessageStrings.loading)
        self.view.addSubview(loadingView)
        
        // send request to API, after get a response, remove the loading screen
        let url = URL(string: urlString)
        Networking.loadMovies(fromUrl: url, completion: { (dictionary) in
            UIView.animate(withDuration: 1, animations: {
                loadingView.removeFromSuperview()
            })
            // TODO: handle the response result from API
            if let items = dictionary?.value(forKey: "items") as? [NSDictionary] {
                print(items.first ?? "nothin")
            }
        })
    }
    
    /**
     create a loading indicator in between of the given view with a label as the given content
     - Create an Activity indicator at center and then create a label with auto layout constraint to an Activity indicator
     - Parameters:
        - view: the given view
        - content: the given content to show on the label
     */
    private func createdLoadingIndicator(in view: UIView, content: String) {
        // activity indicator initialize
        let spinnerHeight: CGFloat = 100
        let spinnerWidth: CGFloat = 100
        let labelHeight: CGFloat = 18
        let spiner = UIActivityIndicatorView(style: .gray)
        spiner.frame = CGRect(x: (view.frame.width - spinnerWidth) / 2 ,
                              y: (view.frame.height - spinnerHeight) / 2 - labelHeight,
                              width: spinnerWidth, height: spinnerHeight)
        spiner.transform = CGAffineTransform(scaleX: 2, y: 2)
        spiner.startAnimating()
        
        // label initialize
        let label = UILabel()
        label.text = content
        label.textColor = UIColor(white: 0.2, alpha: 0.7)
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // add label & activity indicator to the view, add some constraint of the label
        view.addSubview(spiner)
        view.addSubview(label)
        view.addConstraints([
            NSLayoutConstraint(item: label, attribute: .centerX,
                               relatedBy: .equal, toItem: spiner,
                               attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: label, attribute: .top,
                               relatedBy: .equal, toItem: spiner,
                               attribute: .bottom, multiplier: 1.0, constant: 8.0)
            ])
    }

}
