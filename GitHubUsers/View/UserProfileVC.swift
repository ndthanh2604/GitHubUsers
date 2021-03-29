//
//  UserProfileVC.swift
//  GitHubUsers
//
//  Created by ndthanh on 02/04/2021.
//

import UIKit
import RxSwift
import RxDataSources

class UserProfileVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let vm: UserProfileVM
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var dataSource: RxTableViewSectionedReloadDataSource<UserProfileSectionModel>!

    init?(coder: NSCoder, id: Int?) {
        vm = .init(repo: UserRepo(), id: id)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    deinit {
        print("deinit UserListVC")
    }

    func bindViewModel() {
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        dataSource = RxTableViewSectionedReloadDataSource<UserProfileSectionModel>(configureCell: { _, tableView, indexPath, item in
            switch item {
            case .basicInfoItem(item: let item):
                if let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as? UserViewCell {
                    cell.config(with: item)
                    return cell
                }
            case .aboutItem(item: let item):
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AboutViewCell", for: indexPath) as? AboutViewCell {
                    cell.config(bio: item.bio)
                    return cell
                }
            case .statsItem(item: let item):
                if let cell = tableView.dequeueReusableCell(withIdentifier: "StatsViewCell", for: indexPath) as? StatsViewCell {
                    cell.config(with: item)
                    return cell
                }
            }
            return UITableViewCell()
        })

        vm.sectionModels.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    @objc private func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
}

extension UserProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionModels[indexPath.section].items.first
        switch section {
        case .basicInfoItem:
            return 160
        default:
            return UITableView.automaticDimension
        }
    }
}
