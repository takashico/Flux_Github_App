//
//  UserDetailActionCreator.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import RxSwift

final class UserDetailActionCreator: ActionCreator {
    private var userRepository: UserRepository
    
    required init(_ dispatcher: Dispatcher, userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(dispatcher)
    }
    
    func fetchUserDetail(username: String) {
        // 読み込み開始
        dispatch(UserDetailAction.FirstFetchStart())
        
        userRepository.fetchDetail(username: username)
            .subscribe(with: self, onSuccess: { owner, user in
                // 読み込み終了
                owner.dispatch(UserDetailAction.FirstFetchEnd())
                
                owner.dispatch(UserDetailAction.UserDetailFetched(
                    user: user
                ))
                
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserDetailAction.FirstFetchEnd())
                
                owner.dispatch(UserDetailAction.ApiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
    
    // TODO: Reposを取得するアクションを追加する
}
