//
//  GitHubUsersTests.swift
//  GitHubUsersTests
//
//  Created by ndthanh on 29/03/2021.
//

import XCTest
import RxSwift

@testable import GitHubUsers

class GitHubUsersTests: XCTestCase {
    var repo: UserRepoType!
    var vm: UserProfileVM!
    var disposeBag: DisposeBag!

    override func setUp() {
        repo = UserRepoMock()
        vm = .init(repo: repo, id: 2)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        repo = nil
        vm = nil
        disposeBag = nil
    }

    func testUserProfile() {
        vm.sectionModels.subscribe {
            switch $0.element?.first?.items.first {
            case .basicInfoItem(item: let profile):
                XCTAssert(profile.name == "hello")
                XCTAssert(profile.followers == 3)
            default: break
            }
        }.disposed(by: disposeBag)

        vm.getProfile(id: 2)
    }
}
