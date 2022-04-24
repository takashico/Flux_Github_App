//
//  UserDetailViewModel.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import RxSwift

protocol UserDetailViewModelInput {
    func fetchUserDetail(username: String)
}

protocol UserDetailViewModelOutput {
    var user: Observable<UserDetail?> { get }
    var isLoading: Observable<Bool> { get }
    var apiError: Observable<Error?> { get }
}

class UserDetailViewModel: UserDetailViewModelInput, UserDetailViewModelOutput {
    private let actionCreator: UserDetailActionCreator
    private let store: UserDetailStore
    
    var user: Observable<UserDetail?>
    var isLoading: Observable<Bool>
    var apiError: Observable<Error?>
    
    init(actionCreator: UserDetailActionCreator, store: UserDetailStore) {
        self.actionCreator = actionCreator
        self.store = store
        
        self.user = store.state.map { state in
            state.user
        }
        .share()
        
        self.isLoading = store.state.map { state in
            state.isLoading
        }
        .share()
        
        self.apiError = store.state.map { state in
            state.apiError
        }
        .share()
    }
    
    func fetchUserDetail(username: String) {
        actionCreator.fetchUserDetail(username: username)
    }
}
