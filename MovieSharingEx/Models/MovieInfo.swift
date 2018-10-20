//
//  MovieInfo.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import Foundation

struct MovieInfo: Codable {
    public let id: String
    public let title: String
    public let imageUrl: String
    public let description: String
    
    init?(withData data: NSDictionary) {
        guard
            let id = data.nsDictionary(forKeyPath: "contentDetails")?.nsDictionary(forKeyPath: "upload")?.string(forKeyPath: "videoId"),
            let title = data.nsDictionary(forKeyPath: "snippet")?.string(forKeyPath: "title"),
            let description = data.nsDictionary(forKeyPath: "snippet")?.string(forKeyPath: "description"),
            let imageUrl = data.nsDictionary(forKeyPath: "snippet")?.nsDictionary(forKeyPath: "thumbnails")?.nsDictionary(forKeyPath: "standard")?.string(forKeyPath: "url")
            else {
                return nil
        }
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.description = description
    }
}
/*
 json structures:
 data = items: [
    {
     snippet: {
         title: String
         description: String
         thumbnails: {
            medium: {
                url: String
            }
         }
        }
     contentDetails: {
         upload: {
            videoId: String
            }
        }
    }
 ]
 */
