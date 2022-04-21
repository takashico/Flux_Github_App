//
//  UserListViewModel.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift

protocol UserListViewModelInput {
    func fetchUserList()
}

protocol UserListViewModelOutput {
    var list: Observable<[User]> { get }
}

class UserListViewModel: UserListViewModelInput, UserListViewModelOutput {
    private let actionCreator: UserListActionCreator
    private let store: UserListStore
    
    var list: Observable<[User]>
    
    init(actionCreator: UserListActionCreator, store: UserListStore) {
        self.actionCreator = actionCreator
        self.store = store
        
        self.list = store.state.map { state -> [User] in
            state.list
        }
        .share()
    }
    
    func fetchUserList() {
        actionCreator.fetchUserList()
    }
}
