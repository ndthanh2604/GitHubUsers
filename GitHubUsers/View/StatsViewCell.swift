//
//  StatsViewCell.swift
//  GitHubUsers
//
//  Created by ndthanh on 03/04/2021.
//

import UIKit

class StatsViewCell: UITableViewCell {
    @IBOutlet private weak var publicRepoNumberLabel: UILabel!
    @IBOutlet private weak var followersNumberLabel: UILabel!
    @IBOutlet private weak var followingNumberLabel: UILabel!

    func config(with profile: Profile) {
        publicRepoNumberLabel.text = String(profile.publicRepos ?? 0)
        followersNumberLabel.text = String(profile.followers ?? 0)
        followingNumberLabel.text = String(profile.following ?? 0)
    }
}
