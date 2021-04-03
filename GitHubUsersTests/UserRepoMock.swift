//
//  UserRepoMock.swift
//  GitHubUsersTests
//
//  Created by ndthanh on 03/04/2021.
//

import Foundation
import RxSwift

@testable import GitHubUsers

class UserRepoMock: UserRepoType {
    func getUsers() -> Single<[User]> {
        return Single.create { single in
            let users = self.parseUsers(jsonFilename: "UserList")
            single(.success(users))
            return Disposables.create()
        }
    }

    func getProfile(id: Int) -> Single<Profile> {
        return Single.create { single in
            let profile = self.parseProfile(jsonFilename: "UserProfile")
            single(.success(profile))
            return Disposables.create()
        }
    }
}

private extension UserRepoMock {
    func parseUsers(jsonFilename: String) -> [User] {
        guard let fileURL = Bundle(for: UserRepoMock.self).url(forResource: jsonFilename, withExtension: "json"),
              let data = try? Data(contentsOf: fileURL)
        else {
            fatalError("file not found at \(jsonFilename)")
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode([User].self, from: data)
        } catch {
            fatalError("Parse users json failed: \(jsonFilename), error: \(error)")
        }
    }

    func parseProfile(jsonFilename: String) -> Profile {
        guard let fileURL = Bundle(for: UserRepoMock.self).url(forResource: jsonFilename, withExtension: "json"),
              let data = try? Data(contentsOf: fileURL)
        else {
            fatalError("file not found at \(jsonFilename)")
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(Profile.self, from: data)
        } catch {
            fatalError("Parse profile json failed: \(jsonFilename), error: \(error)")
        }
    }
}
