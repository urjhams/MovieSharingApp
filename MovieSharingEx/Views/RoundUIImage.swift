//
//  RoundUIImage.swift
//  MovieSharingEx
//
//  Created by Quân Đinh on 21.10.18.
//  Copyright © 2018 urjhams. All rights reserved.
//

import UIKit

@IBDesignable class RoundUIImage: UIImageView {
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        } set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var maskToBound: Bool {
        get {
            return self.layer.masksToBounds
        } set {
            self.layer.masksToBounds = newValue
        }
    }
}
