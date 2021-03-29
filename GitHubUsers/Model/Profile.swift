//
//  Profile.swift
//  GitHubUsers
//
//  Created by ndthanh on 02/04/2021.
//

import Foundation

struct Profile: Decodable {
    let login: String?
    let avatarUrl: String?
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case name
        case location
        case bio
        case publicRepos = "public_repos"
        case followers
        case following
    }
}
