//
//  UserDetailViewController.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import PKHUD
import RxSwift
import UIKit

class UserDetailViewController: UIViewController {

    private enum SectionType: Int, CaseIterable {
        case userDetail = 0
        case reposList = 1
    }

    @IBOutlet weak var tableView: UITableView!

    // usernameは必須
    var username: String!
    var viewModelInput: UserDetailViewModelInput?
    var viewModelOutput: UserDetailViewModelOutput?

    private let disposeBag = DisposeBag()
    private let indicatorView = UIActivityIndicatorView(style: .medium)
    // ユーザー詳細
    private var user: UserDetail? {
        didSet {
            tableView.reloadSections(IndexSet(integer: SectionType.userDetail.rawValue), with: .fade)
        }
    }
    // リポジトリリスト
    private var reposList = [Repos]() {
        didSet {
            tableView.reloadData()
        }
    }

    private var canReposListFetchMore = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = username

        setUpTableView()

        viewModelInput?.fetchUserDetail(username: username)
        viewModelInput?.fetchReposList(username: username)

        setTableViewSubscribes()
        setViewModelSubscribes()
    }

    private func setUpTableView() {
        // セル登録
        tableView.register(
            UINib(nibName: UserDetailTableViewCell.className, bundle: nil),
            forCellReuseIdentifier: UserDetailTableViewCell.className
        )
        tableView.register(
            UINib(nibName: UserReposTableViewCell.className, bundle: nil),
            forCellReuseIdentifier: UserReposTableViewCell.className
        )

        // tableViewの設定
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func setTableViewSubscribes() {
        // タップアクション
        tableView.rx.itemSelected
            .asSignal()
            .emit(with: self, onNext: { owner, indexPath in
                if SectionType(rawValue: indexPath.section) != .reposList {
                    return
                }

                owner.tableView.deselectRow(at: indexPath, animated: true)

                guard let url = URL(string: owner.reposList[indexPath.row].htmlUrl) else {
                    return
                }

                let viewController = RepositoryDetailViewController()
                viewController.url = url
                owner.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        // 最下部の読み込み処理
        tableView.rx.willDisplayCell
            .asDriver()
            .drive(onNext: { [weak self] _, indexPath in
                if SectionType(rawValue: indexPath.section) != .reposList {
                    return
                }

                guard let strongSelf = self else { return }

                if strongSelf.canReposListFetchMore, indexPath.row >= (strongSelf.reposList.count - 2) {
                    strongSelf.viewModelInput?.fetchMoreReposList(username: strongSelf.username)
                }
            })
            .disposed(by: disposeBag)
    }

    private func setViewModelSubscribes() {
        // ユーザー一覧
        viewModelOutput?.user
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, user in
                owner.user = user
            })
            .disposed(by: disposeBag)

        // リポジトリ一覧
        viewModelOutput?.reposList
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, reposList in
                owner.reposList = reposList
            })
            .disposed(by: disposeBag)

        // 追加取得可能フラグ
        viewModelOutput?.canReposListFetchMore
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, canReposListFetchMore in
                owner.canReposListFetchMore = canReposListFetchMore
            })
            .disposed(by: disposeBag)

        // 全てのデータ取得完了フラグ
        viewModelOutput?.isReposListDataEnded
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, isReposListDataEnded in
                if isReposListDataEnded {
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

        // リポジトリリストのローディング
        viewModelOutput?.isReposListLoading
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, isReposListLoading in
                if isReposListLoading {
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

extension UserDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionType(rawValue: section) {
        case .userDetail:
            return 1
        case .reposList:
            return reposList.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch sectionType {
        case .userDetail:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailTableViewCell.className, for: indexPath) as! UserDetailTableViewCell
            cell.configure(user: user)
            return cell

        case .reposList:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserReposTableViewCell.className, for: indexPath) as! UserReposTableViewCell
            cell.configure(repos: reposList[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
