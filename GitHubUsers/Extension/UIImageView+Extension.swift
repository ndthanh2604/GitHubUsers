//
//  UIImageView+Extension.swift
//  GitHubUsers
//
//  Created by ndthanh on 03/04/2021.
//

import UIKit

extension UIImageView {
    func roundCorner() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
