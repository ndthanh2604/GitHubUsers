//
//  User.swift
//  GitHubUsers
//
//  Created by ndthanh on 30/03/2021.
//

import Foundation

struct User: Decodable {
    let id: Int?
    let login: String?
    let avatarUrl: String?
    let htmlUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}
