//
//  UserDetailStore.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import RxSwift
import RxRelay

protocol UserDetailStore {
    var state: UserDetailState { get }
    var stateObservable: Observable<UserDetailState> { get }
}

final class UserDetailStoreImpl: Store, UserDetailStore {
    
    private let _state = BehaviorRelay<UserDetailState>(
        value: UserDetailState(
            user: nil,
            reposList: [],
            reposPage: 1,
            isLoading: false,
            isReposListFirstFetched: false,
            isReposListLoading: false,
            isReposListDataEnded: false,
            canReposListFetchMore: false,
            apiError: nil
        )
    )
    
    var state: UserDetailState {
        return _state.value
    }
    
    var stateObservable: Observable<UserDetailState> {
        return _state.asObservable()
    }
    
    override func onAction(action: Action) {
        switch action {
        case let action as UserDetailAction:
            onAction(action: action)
        default:
            return
        }
    }
}

extension UserDetailStoreImpl {
    private func onAction(action: UserDetailAction) {
        switch action {
        case .userDetailFetched(let user):
            _state.accept(UserDetailState(
                user: user,
                reposList: state.reposList,
                reposPage: state.reposPage,
                isLoading: false,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: state.isReposListLoading,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: state.canReposListFetchMore,
                apiError: nil
            ))
            
        case .reposListFirstFetched(let reposList, let isDataEnded):
            _state.accept(UserDetailState(
                user: state.user,
                reposList: filteredReposList(reposList: reposList),
                reposPage: 1,
                isLoading: false,
                isReposListFirstFetched: true,
                isReposListLoading: state.isReposListLoading,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: canReposListFetchMore(
                    isLoading: state.isReposListLoading,
                    isDataEnded: isDataEnded,
                    isFirstFetched: true
                ),
                apiError: nil
            ))
            
        case .reposListMoreFetched(let page, let reposList, let isDataEnded):
            _state.accept(UserDetailState(
                user: state.user,
                reposList: state.reposList + filteredReposList(reposList: reposList),
                reposPage: page,
                isLoading: false,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: state.isReposListLoading,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: canReposListFetchMore(
                    isLoading: state.isReposListLoading,
                    isDataEnded: isDataEnded,
                    isFirstFetched: state.isReposListFirstFetched
                ),
                apiError: nil
            ))
            
        case .apiError(let error):
            _state.accept(UserDetailState(
                user: state.user,
                reposList: state.reposList,
                reposPage: state.reposPage,
                isLoading: false,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: state.isReposListLoading,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: state.canReposListFetchMore,
                apiError: error
            ))
            
        case .userDetailFetchStart:
            _state.accept(UserDetailState(
                user: nil,
                reposList: state.reposList,
                reposPage: state.reposPage,
                isLoading: true,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: state.isReposListLoading,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: state.canReposListFetchMore,
                apiError: nil
            ))
            
        case .userDetailFetchEnd:
            _state.accept(UserDetailState(
                user: state.user,
                reposList: state.reposList,
                reposPage: state.reposPage,
                isLoading: false,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: state.isReposListLoading,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: state.canReposListFetchMore,
                apiError: nil
            ))
            
        case .reposListFirstFetchStart:
            _state.accept(UserDetailState(
                user: state.user,
                reposList: [],
                reposPage: 1,
                isLoading: state.isLoading,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: true,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: false,
                apiError: nil
            ))
            
        case .reposListFirstFetchEnd:
            _state.accept(UserDetailState(
                user: state.user,
                reposList: state.reposList,
                reposPage: state.reposPage,
                isLoading: state.isLoading,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: false,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: state.canReposListFetchMore,
                apiError: nil
            ))
            
        case .reposListMoreFetchStart:
            _state.accept(UserDetailState(
                user: state.user,
                reposList: state.reposList,
                reposPage: state.reposPage,
                isLoading: state.isLoading,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: true,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: false,
                apiError: nil
            ))
            
        case .reposListMoreFetchEnd:
            _state.accept(UserDetailState(
                user: state.user,
                reposList: state.reposList,
                reposPage: state.reposPage,
                isLoading: state.isLoading,
                isReposListFirstFetched: state.isReposListFirstFetched,
                isReposListLoading: false,
                isReposListDataEnded: state.isReposListDataEnded,
                canReposListFetchMore: state.canReposListFetchMore,
                apiError: nil
            ))
        }
    }
    /// 表示用のReposListを生成（Forkリポジトリを除く処理）
    private func filteredReposList(reposList: [Repos]) -> [Repos] {
        return reposList.filter { !$0.isFork }
    }
    
    private func canReposListFetchMore(isLoading: Bool, isDataEnded: Bool, isFirstFetched: Bool) -> Bool {
        return !isLoading && !isDataEnded && isFirstFetched
    }
}
