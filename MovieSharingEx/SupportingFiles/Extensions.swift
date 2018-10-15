//
//  Extensions.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 15.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import Foundation

extension NSDictionary {
    func string(forKeyPath keyPath: String) -> String? {
        return value(forKeyPath: keyPath) as? String
    }
}
