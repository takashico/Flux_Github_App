//
//  UserDetailViewModel.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import Foundation
import RxSwift

protocol UserDetailViewModelInput {
    func fetchUserDetail(username: String)
    func fetchReposList(username: String)
    func fetchMoreReposList(username: String)
    func didSelectRepositoryRow(at indexPath: IndexPath)
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

final class UserDetailViewModel: UserDetailViewModelOutput {
    private let PER_PAGE = 20

    private let actionCreator: UserDetailActionCreator
    private let store: UserDetailStore
    private var router: UserDetailRouter?

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

        user = store.stateObservable.map { state in
            state.user
        }
        .share()

        reposList = store.stateObservable.map { state in
            state.reposList
        }
        .share()

        isLoading = store.stateObservable.map { state in
            state.isLoading
        }
        .share()

        isReposListLoading = store.stateObservable.map { state in
            state.isReposListLoading
        }
        .share()

        isReposListDataEnded = store.stateObservable.map { state in
            state.isReposListDataEnded
        }
        .share()

        canReposListFetchMore = store.stateObservable.map { state in
            state.canReposListFetchMore
        }
        .share()

        apiError = store.stateObservable.map { state in
            state.apiError
        }
        .share()
    }

    func injectRouter(_ router: UserDetailRouter) {
        self.router = router
    }
}

extension UserDetailViewModel: UserDetailViewModelInput {
    func fetchUserDetail(username: String) {
        actionCreator.fetchUserDetail(username: username)
    }

    func fetchReposList(username: String) {
        actionCreator.firstFetchUserRepositories(username: username, perPage: PER_PAGE)
    }

    func fetchMoreReposList(username: String) {
        actionCreator.moreFetchUserRepositories(
            username: username,
            page: store.state.reposPage + 1,
            perPage: PER_PAGE
        )
    }

    func didSelectRepositoryRow(at indexPath: IndexPath) {
        guard let url = URL(string: store.state.reposList[indexPath.row].htmlUrl) else {
            return
        }

        router?.transitionToRepositoryDetail(url: url)
    }
}
