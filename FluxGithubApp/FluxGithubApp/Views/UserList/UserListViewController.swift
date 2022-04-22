//
//  UserListViewController.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/20.
//

import UIKit
import SwiftUI
import RxSwift

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModelInput: UserListViewModelInput?
    var viewModelOutput: UserListViewModelOutput?
    
    private let indicatorView = UIActivityIndicatorView(style: .medium)
    private let disposeBag = DisposeBag()
    private var userList = [User]()
    private var canFetchMore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // セル登録
        tableView.register(UINib.init(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
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
        viewModelOutput?.users
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, users in
                print(users.count)
                owner.userList = users
                owner.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModelOutput?.canFetchMore
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, canFetchMore in
                owner.canFetchMore = canFetchMore
            })
            .disposed(by: disposeBag)
        
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
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserListTableViewCell
        cell.configure(user: userList[indexPath.row])
        return cell
    }
    
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
