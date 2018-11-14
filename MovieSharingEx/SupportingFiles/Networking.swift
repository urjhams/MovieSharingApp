//
//  Helper.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import Foundation
import Alamofire

/// The functions relate to networking
public class Networking {
    /**
     get the movies list from API
     - Parameters:
        - url: the url of API
        - completion: when successful get the json from API as NSDictionary, handling that dictionary
     - Warning: Should update the UI in the completion closure, because the process works in a different thread
     */
    public static func loadMovies(fromUrl url: URL?, completion: @escaping (_ resultDict: NSDictionary?) -> ()){
        if let availavleUrl = url {
            Alamofire.request(availavleUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case Constants.YoutubeApi.NetworkStatusCode.ok:
                        if let json = response.value as? NSDictionary {
                            completion(json)
                        }
                    case Constants.YoutubeApi.NetworkStatusCode.badRequest:
                        print("bad request")
                    case Constants.YoutubeApi.NetworkStatusCode.forbidden:
                        print("forbidden")
                    case Constants.YoutubeApi.NetworkStatusCode.notFound:
                        print("not found")
                    default:
                        break
                    }
                }
            }
        }
    }
}
