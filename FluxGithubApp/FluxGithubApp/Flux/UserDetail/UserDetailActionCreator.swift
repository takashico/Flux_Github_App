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
    
    /// ユーザーに紐づくリポジトリ一覧を取得
    func fetchUserRepositories(username: String, page: Int, perPage: Int) {
        // 読み込み開始
        dispatch(UserDetailAction.ReposListFetchStart())
        
        reposRepository.fetchList(username: username, page: page, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, reposList in
                // 読み込み終了
                owner.dispatch(UserDetailAction.ReposListFetchEnd())
                
                if page <= 1 {
                    owner.dispatch(UserDetailAction.ReposListFirstFetched(
                        page: page,
                        reposList: reposList,
                        isDataEnded: reposList.count < perPage
                    ))
                } else {
                    owner.dispatch(UserDetailAction.ReposListMoreFetched(
                        page: page,
                        reposList: reposList,
                        isDataEnded: reposList.count < perPage
                    ))
                }
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserDetailAction.ReposListFetchEnd())
                
                owner.dispatch(UserDetailAction.ApiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
}
