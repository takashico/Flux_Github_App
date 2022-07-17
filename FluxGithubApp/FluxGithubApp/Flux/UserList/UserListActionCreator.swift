//
//  UserListActionCreator.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift

final class UserListActionCreator: ActionCreator {
    private var userRepository: UserRepository
    
    required init(_ dispatcher: Dispatcher, userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(dispatcher)
    }
    
    func firstFetchUserList(perPage: Int) {
        // 読み込み開始
        dispatch(UserListAction.firstFetchStart)
        
        userRepository.fetchList(since: 0, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, users in
                // 読み込み終了
                owner.dispatch(UserListAction.firstFetchEnd)
                
                owner.dispatch(UserListAction.firstFetched(
                    isDataEnded: users.count < perPage,
                    users: users
                ))
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserListAction.firstFetchEnd)
                
                owner.dispatch(UserListAction.apiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
    
    func moreFetchUserList(since: Int, perPage: Int) {
        // 読み込み開始
        dispatch(UserListAction.moreFetchStart)
        
        userRepository.fetchList(since: since, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, users in
                // 読み込み終了
                owner.dispatch(UserListAction.moreFetchEnd)
                
                owner.dispatch(UserListAction.moreFetched(
                    isDataEnded: users.count < perPage,
                    users: users
                ))
            }, onFailure: { owner, error in
                // 読み込み終了
                owner.dispatch(UserListAction.moreFetchEnd)
                
                owner.dispatch(UserListAction.apiError(
                    error: error
                ))
            })
            .disposed(by: disposeBag)
    }
}
