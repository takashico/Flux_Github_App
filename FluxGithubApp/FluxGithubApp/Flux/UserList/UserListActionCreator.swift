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
    
    func fetchUserList() {
        userRepository.fetchList()
            .subscribe { [weak self] list in
                self?.dispatch(UserListAction.Fetched(
                    list: list
                ))
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}
