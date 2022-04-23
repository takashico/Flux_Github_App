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
        dispatch(UserListAction.FirstFetchStart())
        
        userRepository.fetchList(since: 0, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, users in
                // 読み込み終了
                owner.dispatch(UserListAction.FirstFetchEnd())
                
                owner.dispatch(UserListAction.FirstFetched(
                    isDataEnded: users.count < perPage,
                    users: users
                ))
            }, onFailure: { _, error in
                // TODO: APIエラーアクションとして流す
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func moreFetchUserList(since: Int, perPage: Int) {
        // 読み込み開始
        dispatch(UserListAction.MoreFetchStart())
        
        userRepository.fetchList(since: since, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, users in
                // 読み込み終了
                owner.dispatch(UserListAction.MoreFetchEnd())
                
                owner.dispatch(UserListAction.MoreFetched(
                    isDataEnded: users.count < perPage,
                    users: users
                ))
            }, onFailure: { _, error in
                // TODO: APIエラーアクションとして流す
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
