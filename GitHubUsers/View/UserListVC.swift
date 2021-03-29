//
//  UserListVC.swift
//  GitHubUsers
//
//  Created by ndthanh on 29/03/2021.
//

import UIKit
import RxSwift
import RxDataSources

class UserListVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let vm = UserListVM(repo: UserRepo())
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()

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
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        let input = UserListVM.Input(selection: tableView.rx.modelSelected(User.self).asObservable())
        let output = vm.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<UserListSectionModel>(configureCell: { _, tableView, indexPath, item in
            let cell: UserViewCell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
            cell.config(with: item)
            return cell
        })

        output.items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        output.selectItemEvent.subscribe(onNext: { [weak self] selectionItem in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "UserProfileVC", creator: { coder in
                UserProfileVC(coder: coder, id: selectionItem.id)
            })
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    @objc private func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
}

extension UserListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
