//
//  UserListViewController.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/20.
//

import UIKit
import SwiftUI
import RxSwift
import PKHUD

class UserListViewController: UIViewController {
    
    private enum SectionType: CaseIterable {
        case userList
    }

    @IBOutlet weak var tableView: UITableView!
    
    var viewModelInput: UserListViewModelInput?
    var viewModelOutput: UserListViewModelOutput?
    
    private let indicatorView = UIActivityIndicatorView(style: .medium)
    private let disposeBag = DisposeBag()
    private var userList = [User]() {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<SectionType, User>()
            snapshot.appendSections(SectionType.allCases)
            snapshot.appendItems(userList, toSection: .userList)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    private var canFetchMore: Bool = false
    
    private lazy var dataSource: UITableViewDiffableDataSource<SectionType, User> = {
        let dataSource = UITableViewDiffableDataSource<SectionType, User>(tableView: tableView) { tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserListTableViewCell
            cell.configure(user: user)
            return cell
        }
        
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // セル登録
        tableView.register(UINib.init(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // tableViewの設定
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        viewModelInput?.fetchUserList()
        
        setBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // indicatorViewの設定
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)
    }
    
    private func setBindings() {
        // ユーザー一覧
        viewModelOutput?.users
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, users in
                print(users.count)
                owner.userList = users
            })
            .disposed(by: disposeBag)
        
        // 追加取得可能フラグ
        viewModelOutput?.canFetchMore
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, canFetchMore in
                owner.canFetchMore = canFetchMore
            })
            .disposed(by: disposeBag)
        
        // 全てのデータ取得完了フラグ
        viewModelOutput?.isDataEnded
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, isDataEnded in
                if isDataEnded {
                    owner.tableView.tableFooterView = UIView()
                } else {
                    owner.tableView.tableFooterView = owner.indicatorView
                }
            })
            .disposed(by: disposeBag)
        
        // ローディング
        viewModelOutput?.isLoading
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isLoading in
                if isLoading {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            })
            .disposed(by: disposeBag)
        
        // 追加読み込みのローディング
        viewModelOutput?.isMoreLoading
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, isMoreLoading in
                if isMoreLoading {
                    owner.indicatorView.startAnimating()
                } else {
                    owner.indicatorView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        // APIエラー
        viewModelOutput?.apiError
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { error in
                guard let error = error else { return }
                HUD.show(.labeledError(title: "Network Error", subtitle: error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.canFetchMore && indexPath.row >= (userList.count - 2) {
            // 次ページデータ取得
            viewModelInput?.fetchMore()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
