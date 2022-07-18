//
//  UserListViewModel.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift

protocol UserListViewModelInput {
    func fetchUserList()
    func fetchMore()
}

protocol UserListViewModelOutput {
    var users: Observable<[User]> { get }
    var canFetchMore: Observable<Bool> { get }
    var isDataEnded: Observable<Bool> { get }
    var isLoading: Observable<Bool> { get }
    var isMoreLoading: Observable<Bool> { get }
    var apiError: Observable<Error?> { get }
}

class UserListViewModel: UserListViewModelInput, UserListViewModelOutput {
    private let PER_PAGE = 20
    
    private let actionCreator: UserListActionCreator
    private let store: UserListStore
    
    var users: Observable<[User]>
    var canFetchMore: Observable<Bool>
    var isDataEnded: Observable<Bool>
    var isLoading: Observable<Bool>
    var isMoreLoading: Observable<Bool>
    var apiError: Observable<Error?>
    
    init(actionCreator: UserListActionCreator, store: UserListStore) {
        self.actionCreator = actionCreator
        self.store = store
        
        
        self.users = store.stateObservable.map { state in
            state.users
        }
        .share()
        
        self.canFetchMore = store.stateObservable.map { state in
            state.canFetchMore
        }
        .share()
        
        self.isDataEnded = store.stateObservable.map { state in
            state.isDataEnded
        }
        .share()
        
        self.isLoading = store.stateObservable.map { state in
            state.isLoading
        }
        .share()
        
        self.isMoreLoading = store.stateObservable.map { state in
            state.isMoreLoading
        }
        .share()
        
        self.apiError = store.stateObservable.map { state in
            state.apiError
        }
        .share()
    }
    
    func fetchUserList() {
        actionCreator.firstFetchUserList(perPage: PER_PAGE)
    }
    
    func fetchMore() {
        guard let since = store.state.users.last?.id else { return }
        
        actionCreator.moreFetchUserList(since: since, perPage: PER_PAGE)
    }
}
