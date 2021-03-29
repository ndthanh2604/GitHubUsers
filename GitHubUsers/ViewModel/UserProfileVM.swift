//
//  UserProfileVM.swift
//  GitHubUsers
//
//  Created by ndthanh on 02/04/2021.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import CoreData

enum UserProfileSectionItem {
    case basicInfoItem(item: Profile)
    case aboutItem(item: Profile)
    case statsItem(item: Profile)
}

class UserProfileSectionModel: SectionModelType {
    typealias Item = UserProfileSectionItem
    var items: [Item]

    required init(original: UserProfileSectionModel, items: [UserProfileSectionItem]) {
        self.items = items
    }

    init(items: [Item]) {
        self.items = items
    }
}

class UserProfileVM {
    let repo: UserRepoType
    let disposeBag = DisposeBag()
    let sectionModels = PublishRelay<[UserProfileSectionModel]>()

    init(repo: UserRepoType, id: Int?) {
        self.repo = repo
        getProfile(id: id)
    }

    func getProfile(id: Int?) {
        guard let id = id else { return }
        repo.getProfile(id: id).subscribe {
            switch $0 {
            case let .success(profile):
                self.sectionsModelsAccept(profile)
            case let .failure(error):
                print("Error - Get profile: \(error.localizedDescription)")

                DispatchQueue.main.async {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileData")

                    do {
                        let profileObjects = try managedContext.fetch(fetchRequest)
                        let profileObject = profileObjects.first(where: { ($0.value(forKeyPath: "login") as? String) == String(id) })
                        let profile = Profile(login: profileObject?.value(forKeyPath: "avatarUrl") as? String,
                                              avatarUrl: profileObject?.value(forKeyPath: "avatarUrl") as? String,
                                              name: profileObject?.value(forKeyPath: "name") as? String,
                                              location: profileObject?.value(forKeyPath: "location") as? String,
                                              bio: profileObject?.value(forKeyPath: "bio") as? String,
                                              publicRepos: profileObject?.value(forKeyPath: "publicRepos") as? Int,
                                              followers: profileObject?.value(forKeyPath: "followers") as? Int,
                                              following: profileObject?.value(forKeyPath: "following") as? Int)
                        self.sectionsModelsAccept(profile)
                    } catch let error as NSError {
                        print("Could not fetch. \(error), \(error.userInfo)")
                    }
                }
            }

        }.disposed(by: disposeBag)
    }

    func sectionsModelsAccept(_ profile: Profile) {
        var sections = [UserProfileSectionModel]()
        sections.append(UserProfileSectionModel(items: [.basicInfoItem(item: profile)]))
        sections.append(UserProfileSectionModel(items: [.aboutItem(item: profile)]))
        sections.append(UserProfileSectionModel(items: [.statsItem(item: profile)]))
        sectionModels.accept(sections)
    }
}
