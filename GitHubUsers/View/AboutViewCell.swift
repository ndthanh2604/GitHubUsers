//
//  AboutViewCell.swift
//  GitHubUsers
//
//  Created by ndthanh on 03/04/2021.
//

import UIKit

class AboutViewCell: UITableViewCell {
    @IBOutlet private weak var bioLabel: UILabel!

    func config(bio: String?) {
        bioLabel.text = bio ?? "None"
    }
}
