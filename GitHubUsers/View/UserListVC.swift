//
//  UserListVC.swift
//  GitHubUsers
//
//  Created by ndthanh on 29/03/2021.
//

import UIKit

class UserListVC: UIViewController {
    let vm: UserListVM = .init(repo: UserRepo())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit UserListVC")
    }

}

