//
//  UserDetailViewModel.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import RxSwift

protocol UserDetailViewModelInput {
    func fetchUserDetail(username: String)
    func fetchReposList(username: String)
    func fetchMoreReposList(username: String)
}

protocol UserDetailViewModelOutput {
    var user: Observable<UserDetail?> { get }
    var reposList: Observable<[Repos]> { get }
    var isLoading: Observable<Bool> { get }
    var isReposListLoading: Observable<Bool> { get }
    var isReposListDataEnded: Observable<Bool> { get }
    var canReposListFetchMore: Observable<Bool> { get }
    var apiError: Observable<Error?> { get }
}

class UserDetailViewModel: UserDetailViewModelInput, UserDetailViewModelOutput {
    private let PER_PAGE = 20
    
    private let actionCreator: UserDetailActionCreator
    private let store: UserDetailStore
    
    var user: Observable<UserDetail?>
    var reposList: Observable<[Repos]>
    var isLoading: Observable<Bool>
    var isReposListLoading: Observable<Bool>
    var isReposListDataEnded: Observable<Bool>
    var canReposListFetchMore: Observable<Bool>
    var apiError: Observable<Error?>
    
    init(actionCreator: UserDetailActionCreator, store: UserDetailStore) {
        self.actionCreator = actionCreator
        self.store = store
        
        self.user = store.state.map { state in
            state.user
        }
        .share()
        
        self.reposList = store.state.map { state in
            state.reposList
        }
        .share()
        
        self.isLoading = store.state.map { state in
            state.isLoading
        }
        .share()
        
        self.isReposListLoading = store.state.map { state in
            state.isReposListLoading
        }
        .share()
        
        self.isReposListDataEnded = store.state.map { state in
            state.isReposListDataEnded
        }
        .share()
        
        self.canReposListFetchMore = store.state.map { state in
            state.canReposListFetchMore
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
    
    func fetchReposList(username: String) {
        actionCreator.fetchUserRepositories(
            username: username,
            page: 1,
            perPage: PER_PAGE
        )
    }
    
    func fetchMoreReposList(username: String) {
        let state = store.state.value
        
        actionCreator.fetchUserRepositories(
            username: username,
            page: state.reposPage + 1,
            perPage: PER_PAGE
        )
    }
}
