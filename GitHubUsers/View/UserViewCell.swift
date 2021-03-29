//
//  UserViewCell.swift
//  GitHubUsers
//
//  Created by ndthanh on 30/03/2021.
//

import UIKit
import Kingfisher

class UserViewCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var subLabel: UILabel!

    func config(with user: User) {
        avatarImageView.roundCorner()
        if let avatar = user.avatarUrl {
            avatarImageView.kf.setImage(with: URL(string: avatar))
        }
        mainLabel.text = user.login
        subLabel.text = user.htmlUrl
    }

    func config(with profile: Profile) {
        avatarImageView.roundCorner()
        if let avatar = profile.avatarUrl {
            avatarImageView.kf.setImage(with: URL(string: avatar))
        }
        mainLabel.text = profile.name
        subLabel.text = profile.location
    }
}
