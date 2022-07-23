//
//  UserDetailActionCreator.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import RxSwift

protocol UserDetailActionCreator {
    func fetchUserDetail(username: String)
    func firstFetchUserRepositories(username: String, perPage: Int)
    func moreFetchUserRepositories(username: String, page: Int, perPage: Int)
}

final class UserDetailActionCreatorImpl: ActionCreator, UserDetailActionCreator {
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
        dispatch(UserDetailAction.userDetailFetchStart)
        
        userRepository.fetchDetail(username: username)
            .subscribe(with: self, onSuccess: { owner, user in
                // 読み込み終了
                owner.dispatch(UserDetailAction.userDetailFetchEnd)
                
                owner.dispatch(UserDetailAction.userDetailFetched(
                    user: user
                ))
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserDetailAction.userDetailFetchEnd)
                
                owner.dispatch(UserDetailAction.apiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
    
    /// ユーザーに紐づくリポジトリ一覧を取得（初回）
    func firstFetchUserRepositories(username: String, perPage: Int) {
        // 読み込み開始
        dispatch(UserDetailAction.reposListFirstFetchStart)
        
        reposRepository.fetchList(username: username, page: 1, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, reposList in
                // 読み込み終了
                owner.dispatch(UserDetailAction.reposListFirstFetchEnd)
                
                owner.dispatch(UserDetailAction.reposListFirstFetched(
                    reposList: reposList,
                    isDataEnded: reposList.count < perPage
                ))
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserDetailAction.reposListFirstFetchEnd)
                
                owner.dispatch(UserDetailAction.apiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
    
    /// ユーザーに紐づくリポジトリ一覧を取得（追加読み込み）
    func moreFetchUserRepositories(username: String, page: Int, perPage: Int) {
        // 読み込み開始
        dispatch(UserDetailAction.reposListMoreFetchStart)
        
        reposRepository.fetchList(username: username, page: page, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, reposList in
                // 読み込み終了
                owner.dispatch(UserDetailAction.reposListMoreFetchEnd)
                
                owner.dispatch(UserDetailAction.reposListMoreFetched(
                    page: page,
                    reposList: reposList,
                    isDataEnded: reposList.count < perPage
                ))
                
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserDetailAction.reposListMoreFetchEnd)
                
                owner.dispatch(UserDetailAction.apiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
}
