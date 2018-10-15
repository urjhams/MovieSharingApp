//
//  MovieInfo.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import Foundation

struct MovieInfo {
    public let id: String
    public let title: String
    public let imageUrl: String
    public let description: String
    
    init?(withData data: NSDictionary) {
        guard
            let id = data.string(forKeyPath: ""),
            let title = data.string(forKeyPath: ""),
            let imageUrl = data.string(forKeyPath: ""),
            let description = data.string(forKeyPath: "")
            else {
                return nil
        }
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.description = description
    }
}
