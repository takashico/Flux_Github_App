//
//  UserDetailActionCreator.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import RxSwift

final class UserDetailActionCreator: ActionCreator {
    private var userRepository: UserRepository
    private var reposRepository: ReposRepository
    
    required init(
        _ dispatcher: Dispatcher,
        userRepository: UserRepository,
        reposRepository: ReposRepository
    ) {
        self.userRepository = userRepository
        self.reposRepository = reposRepository
        super.init(dispatcher)
    }
    
    /// ユーザー詳細情報を取得
    func fetchUserDetail(username: String) {
        // 読み込み開始
        dispatch(UserDetailAction.UserDetailFetchStart())
        
        userRepository.fetchDetail(username: username)
            .subscribe(with: self, onSuccess: { owner, user in
                // 読み込み終了
                owner.dispatch(UserDetailAction.UserDetailFetchEnd())
                
                owner.dispatch(UserDetailAction.UserDetailFetched(
                    user: user
                ))
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserDetailAction.UserDetailFetchEnd())
                
                owner.dispatch(UserDetailAction.ApiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
    
    /// ユーザーに紐づくリポジトリ一覧を取得（初回）
    func firstFetchUserRepositories(username: String, perPage: Int) {
        // 読み込み開始
        dispatch(UserDetailAction.ReposListFirstFetchStart())
        
        reposRepository.fetchList(username: username, page: 1, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, reposList in
                // 読み込み終了
                owner.dispatch(UserDetailAction.ReposListFirstFetchEnd())
                
                owner.dispatch(UserDetailAction.ReposListFirstFetched(
                    reposList: reposList,
                    isDataEnded: reposList.count < perPage
                ))
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserDetailAction.ReposListFirstFetchEnd())
                
                owner.dispatch(UserDetailAction.ApiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
    
    /// ユーザーに紐づくリポジトリ一覧を取得（追加読み込み）
    func moreFetchUserRepositories(username: String, page: Int, perPage: Int) {
        // 読み込み開始
        dispatch(UserDetailAction.ReposListMoreFetchStart())
        
        reposRepository.fetchList(username: username, page: page, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, reposList in
                // 読み込み終了
                owner.dispatch(UserDetailAction.ReposListMoreFetchEnd())
                
                owner.dispatch(UserDetailAction.ReposListMoreFetched(
                    page: page,
                    reposList: reposList,
                    isDataEnded: reposList.count < perPage
                ))
                
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserDetailAction.ReposListMoreFetchEnd())
                
                owner.dispatch(UserDetailAction.ApiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
}
