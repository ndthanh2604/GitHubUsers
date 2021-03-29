//
//  UserListVM.swift
//  GitHubUsers
//
//  Created by ndthanh on 30/03/2021.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import CoreData

struct UserListSectionModel: SectionModelType {
    typealias Item = User
    var items: [Item]

    init(original: UserListSectionModel, items: [User]) {
        self.items = items
    }

    init(items: [Item]) {
        self.items = items
    }
}

class UserListVM {
    struct Input {
        let selection: Observable<User>
    }

    struct Output {
        let items: Observable<[UserListSectionModel]>
        let selectItemEvent: PublishRelay<User>
    }

    let repo: UserRepoType
    let sectionModels = [UserListSectionModel]()
    let disposeBag = DisposeBag()

    init(repo: UserRepoType) {
        self.repo = repo
    }

    func transform(input: Input) -> Output {
        let items = BehaviorRelay<[UserListSectionModel]>(value: sectionModels)
        let selectItemEvent = PublishRelay<User>()

        func itemsAccept(_ users: [User]) {
            let sectionModel = UserListSectionModel(items: users)
            items.accept([sectionModel])
        }

        repo.getUsers().subscribe {
            switch $0 {
            case let .success(users):
                itemsAccept(users)
            case let .failure(error):
                print("Error - Get users: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserData")

                    do {
                        let userObjects = try managedContext.fetch(fetchRequest)
                        var users = [User]()
                        userObjects.forEach { users.append(User(id: $0.value(forKeyPath: "id") as? Int,
                                                                login: $0.value(forKeyPath: "login") as? String,
                                                                avatarUrl: $0.value(forKeyPath: "avatarUrl") as? String,
                                                                htmlUrl: $0.value(forKeyPath: "htmlUrl") as? String)) }
                        itemsAccept(users)
                    } catch let error as NSError {
                        print("Could not fetch. \(error), \(error.userInfo)")
                    }
                }
            }
        }.disposed(by: disposeBag)

        input.selection.subscribe(onNext: { sectionItem in
            selectItemEvent.accept(sectionItem)
        }).disposed(by: disposeBag)

        return Output(items: items.asObservable(), selectItemEvent: selectItemEvent)
    }
}
