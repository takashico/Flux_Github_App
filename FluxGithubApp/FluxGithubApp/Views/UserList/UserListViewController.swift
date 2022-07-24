//
//  UserListViewController.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/20.
//

import PKHUD
import RxSwift
import UIKit

class UserListViewController: UIViewController {

    private enum SectionType: CaseIterable {
        case userList
    }

    @IBOutlet private weak var tableView: UITableView!

    var viewModelInput: UserListViewModelInput?
    var viewModelOutput: UserListViewModelOutput?

    private let disposeBag = DisposeBag()
    private let indicatorView = UIActivityIndicatorView(style: .medium)
    private lazy var dataSource: UITableViewDiffableDataSource<SectionType, User> = {
        let dataSource = UITableViewDiffableDataSource<SectionType, User>(tableView: tableView) { tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.className, for: indexPath) as! UserListTableViewCell
            cell.configure(user: user)
            return cell
        }

        return dataSource
    }()
    // ユーザーリスト
    private var userList = [User]() {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<SectionType, User>()
            snapshot.appendSections(SectionType.allCases)
            snapshot.appendItems(userList, toSection: .userList)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    private var canFetchMore = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationController()
        setUpTableView()

        viewModelInput?.fetchUserList()

        setTableViewSubscribes()
        setViewModelSubscribes()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // indicatorViewの設定
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)
    }

    private func setUpNavigationController() {
        title = "User List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    private func setUpTableView() {
        // セル登録
        tableView.register(
            UINib(nibName: UserListTableViewCell.className, bundle: nil),
            forCellReuseIdentifier: UserListTableViewCell.className
        )

        // tableViewの設定
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func setTableViewSubscribes() {
        // タップアクション
        tableView.rx.itemSelected
            .asSignal()
            .emit(with: self, onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
                owner.viewModelInput?.didSelectRow(at: indexPath)
            })
            .disposed(by: disposeBag)

        // 最下部の読み込み処理
        tableView.rx.willDisplayCell
            .asDriver()
            .drive(onNext: { [weak self] _, indexPath in
                guard let strongSelf = self else { return }

                if strongSelf.canFetchMore, indexPath.row >= (strongSelf.userList.count - 2) {
                    // 次ページデータ取得
                    strongSelf.viewModelInput?.fetchMore()
                }
            })
            .disposed(by: disposeBag)
    }

    private func setViewModelSubscribes() {
        // ユーザー一覧
        viewModelOutput?.users
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, users in
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
