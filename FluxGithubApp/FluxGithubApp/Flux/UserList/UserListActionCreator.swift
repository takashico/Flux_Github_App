//
//  UserListActionCreator.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift

final class UserListActionCreator: ActionCreator {
    private let PER_PAGE = 20
    
    private var userRepository: UserRepository
    
    required init(_ dispatcher: Dispatcher, userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(dispatcher)
    }
    
    func fetchUserList(page: Int) {
        userRepository.fetchList(page: page, perPage: PER_PAGE)
            .subscribe { [weak self] list in
                guard let strongSelf = self else { return }
                
                if page <= 1 {
                    strongSelf.dispatch(UserListAction.FirstFetched(
                        isDataEnded: list.count < strongSelf.PER_PAGE,
                        list: list
                    ))
                } else {
                    strongSelf.dispatch(UserListAction.MoreFetched(
                        page: page,
                        isDataEnded: list.count < strongSelf.PER_PAGE,
                        list: list
                    ))
                }
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}
