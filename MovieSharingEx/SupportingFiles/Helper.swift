//
//  Helper.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import Foundation
import Alamofire

public class Helper {
    public static func loadMovies(completion: @escaping (_ resultDict: NSDictionary?) -> ()){
        var result: NSDictionary?
        if let url = URL(string: Constants.YoutubeApi.baseUrl) {
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case Constants.YoutubeApi.NetworkStatusCode.ok:
                        if let json = response.value as? NSDictionary {
                            result = json
                            completion(result)
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
