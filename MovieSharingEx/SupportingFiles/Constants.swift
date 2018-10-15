//
//  Constants.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import Foundation

struct Constants {
    struct YoutubeApi {
        static let baseUrl = "https://www.googleapis.com/youtube/v3/activities?part=contentDetails%2C+snippet&channelId=UClgRkhTL3_hImCAmdLfDE4g&maxResults=10&key=\(key)"
        static let key = "AIzaSyD5PSKE5l2VP7EmsCrVvaMfQXu8BS5_PcE"
        struct NetworkStatusCode {
            static let ok = 200
            static let badRequest = 400
            static let forbidden = 403
            static let notFound = 404
        }
    }
    struct MessageStrings {
        static let loading = "Loading movies"
    }
}




