//
//  TabBarViewController.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingMovie()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
    }
    
    private func loadingMovie() {
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        let spinnerWithMess = createdLoadingIndicator(in: loadingView, content: Constants.MessageStrings.loading)
        loadingView.addSubview(spinnerWithMess.0)
        loadingView.addSubview(spinnerWithMess.1)
        self.view.addSubview(loadingView)
        Helper.loadMovies(completion: { /*[weak self]*/ (dictionary) in
            loadingView.removeFromSuperview()
            if let items = dictionary?.value(forKey: "items") as? [NSDictionary] {
                print(items.first ?? "nothin")
            }
            //print(dictionary ?? "nothin")
        })
    }
    
    private func createdLoadingIndicator(in view: UIView, content: String) -> (UIActivityIndicatorView, UILabel) {
        let spinnerHeight: CGFloat = 100
        let spinnerWidth: CGFloat = 100
        let labelHeight: CGFloat = 18
        let spiner = UIActivityIndicatorView(style: .gray)
        spiner.frame = CGRect(x: (view.frame.width - spinnerWidth) / 2 ,
                              y: (view.frame.height - spinnerHeight) / 2 - labelHeight,
                              width: spinnerWidth, height: spinnerHeight)
        spiner.transform = CGAffineTransform(scaleX: 2, y: 2)
        spiner.startAnimating()
        
        let label = UILabel()
        label.text = content
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        
        return (spiner, label)
    }

}
