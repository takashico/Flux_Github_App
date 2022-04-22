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
    
    func fetchUserList(page: Int, perPage: Int) {
        userRepository.fetchList(page: page, perPage: perPage)
            .subscribe(with: self, onSuccess: { owner, list in
                if page <= 1 {
                    owner.dispatch(UserListAction.FirstFetched(
                        isDataEnded: list.count < perPage,
                        list: list
                    ))
                } else {
                    owner.dispatch(UserListAction.MoreFetched(
                        page: page,
                        isDataEnded: list.count < perPage,
                        list: list
                    ))
                }
            }, onFailure: { _, error in
                // APIエラーアクションとして流す
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
