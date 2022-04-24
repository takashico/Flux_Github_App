//
//  UserDetailViewController.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import UIKit
import RxSwift
import PKHUD

class UserDetailViewController: UIViewController {
    
    private enum SectionType: CaseIterable {
        case userDetail
        case repositories
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource: UITableViewDiffableDataSource<SectionType, UserDetail> = {
        let dataSource = UITableViewDiffableDataSource<SectionType, UserDetail>(tableView: tableView) { tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailTableViewCell.className, for: indexPath) as! UserDetailTableViewCell
            cell.configure(user: user)
            return cell
        }
        
        return dataSource
    }()
    
    private var user: UserDetail? {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<SectionType, UserDetail>()
            snapshot.appendSections(SectionType.allCases)
            if let user = user {
                snapshot.appendItems([user], toSection: .userDetail)
            } else {
                snapshot.appendItems([], toSection: .userDetail)
            }
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    var viewModelInput: UserDetailViewModelInput?
    var viewModelOutput: UserDetailViewModelOutput?
    // usernameは必須
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // セル登録
        tableView.register(UINib.init(nibName: UserDetailTableViewCell.className, bundle: nil), forCellReuseIdentifier: UserDetailTableViewCell.className)
        
        viewModelInput?.fetchUserDetail(username: username)
        
        setTableViewSubscribes()
        setViewModelSubscribes()
    }
    
    private func setTableViewSubscribes() {
        // タップアクション
//        tableView.rx.itemSelected
//            .asSignal()
//            .emit(with: self, onNext: { owner, indexPath in
//                // TODO: リポジトリセクションのみWebViewに遷移する
//                owner.tableView.deselectRow(at: indexPath, animated: true)
//                print(indexPath)
//            })
//            .disposed(by: disposeBag)
//
//        // 最下部の読み込み処理
//        tableView.rx.willDisplayCell
//            .asDriver()
//            .drive(onNext: { [weak self] cell, indexPath in
//                guard let strongSelf = self else { return }
//
//                // TODO: リポジトリセクションのみ対応する
//            })
//            .disposed(by: disposeBag)
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
