//
//  UserRepo.swift
//  GitHubUsers
//
//  Created by ndthanh on 30/03/2021.
//

import UIKit
import RxSwift
import CoreData

protocol UserRepoType {
    func getUsers() -> Single<[User]>
    func getProfile(id: Int) -> Single<Profile>
}

class UserRepo: UserRepoType {
    func getUsers() -> Single<[User]> {
        return Single.create { single in
            if let url = URL(string: "https://api.github.com/users") {
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data else {
                        print("No data")
                        if let error = error {
                            single(.failure(error))
                        }
                        return
                    }
                    do {
                        let users = try JSONDecoder().decode([User].self, from: data)
                        users.forEach { self.save($0) }
                        single(.success(users))
                    } catch {
                        single(.failure(error))
                    }
                }
                task.resume()
            }

            return Disposables.create()
        }
    }

    func getProfile(id: Int) -> Single<Profile> {
        return Single.create { single in
            if let url = URL(string: "https://api.github.com/users/\(id)") {
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data else {
                        print("No data")
                        if let error = error {
                            single(.failure(error))
                        }
                        return
                    }
                    do {
                        let profile = try JSONDecoder().decode(Profile.self, from: data)
                        self.save(profile)
                        single(.success(profile))
                    } catch {
                        single(.failure(error))
                    }
                }
                task.resume()
            }

            return Disposables.create()
        }
    }
}

private extension UserRepo {
    func save(_ user: User) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: "UserData", in: managedContext) {
                let userObject = NSManagedObject(entity: entity, insertInto: managedContext)
                userObject.setValue(user.id, forKeyPath: "id")
                userObject.setValue(user.login, forKeyPath: "login")
                userObject.setValue(user.avatarUrl, forKeyPath: "avatarUrl")
                userObject.setValue(user.htmlUrl, forKeyPath: "htmlUrl")

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }

    func save(_ profile: Profile) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: "ProfileData", in: managedContext) {
                let profileObject = NSManagedObject(entity: entity, insertInto: managedContext)
                profileObject.setValue(profile.login, forKeyPath: "login")
                profileObject.setValue(profile.avatarUrl, forKeyPath: "avatarUrl")
                profileObject.setValue(profile.name, forKeyPath: "name")
                profileObject.setValue(profile.location, forKeyPath: "location")
                profileObject.setValue(profile.bio, forKeyPath: "bio")
                profileObject.setValue(profile.publicRepos, forKeyPath: "publicRepos")
                profileObject.setValue(profile.followers, forKeyPath: "followers")
                profileObject.setValue(profile.following, forKeyPath: "following")

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
}
