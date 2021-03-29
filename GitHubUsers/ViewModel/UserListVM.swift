//
//  UserListVM.swift
//  GitHubUsers
//
//  Created by ndthanh on 30/03/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct UserListVM {
    let repo: UserRepoType
    var users: [User] = []
    
    init(repo: UserRepoType) {
        self.repo = repo
    }
}
