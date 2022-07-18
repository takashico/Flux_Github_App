//
//  UserDetailStore.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import RxSwift
import RxRelay

final class UserDetailStore: Store {
    
    let state = BehaviorRelay<UserDetailState>(
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
    
    override func onAction(action: Action) {
        switch action {
        case let action as UserDetailAction:
            onAction(action: action)
        default:
            return
        }
    }
}

extension UserDetailStore {
    private func onAction(action: UserDetailAction) {
        let current = state.value
        
        switch action {
        case .userDetailFetched(let user):
            state.accept(UserDetailState(
                user: user,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: false,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: current.canReposListFetchMore,
                apiError: nil
            ))
            
        case .reposListFirstFetched(let reposList, let isDataEnded):
            state.accept(UserDetailState(
                user: current.user,
                reposList: filteredReposList(reposList: reposList),
                reposPage: 1,
                isLoading: false,
                isReposListFirstFetched: true,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: canReposListFetchMore(
                    isLoading: current.isReposListLoading,
                    isDataEnded: isDataEnded,
                    isFirstFetched: true
                ),
                apiError: nil
            ))
            
        case .reposListMoreFetched(let page, let reposList, let isDataEnded):
            state.accept(UserDetailState(
                user: current.user,
                reposList: current.reposList + filteredReposList(reposList: reposList),
                reposPage: page,
                isLoading: false,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: canReposListFetchMore(
                    isLoading: current.isReposListLoading,
                    isDataEnded: isDataEnded,
                    isFirstFetched: current.isReposListFirstFetched
                ),
                apiError: nil
            ))
            
        case .apiError(let error):
            state.accept(UserDetailState(
                user: current.user,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: false,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: current.canReposListFetchMore,
                apiError: error
            ))
            
        case .userDetailFetchStart:
            state.accept(UserDetailState(
                user: nil,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: true,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: current.canReposListFetchMore,
                apiError: nil
            ))
            
        case .userDetailFetchEnd:
            state.accept(UserDetailState(
                user: current.user,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: false,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: current.canReposListFetchMore,
                apiError: nil
            ))
            
        case .reposListFirstFetchStart:
            state.accept(UserDetailState(
                user: current.user,
                reposList: [],
                reposPage: 1,
                isLoading: current.isLoading,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: true,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: false,
                apiError: nil
            ))
            
        case .reposListFirstFetchEnd:
            state.accept(UserDetailState(
                user: current.user,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: current.isLoading,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: false,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: current.canReposListFetchMore,
                apiError: nil
            ))
            
        case .reposListMoreFetchStart:
            state.accept(UserDetailState(
                user: current.user,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: current.isLoading,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: true,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: false,
                apiError: nil
            ))
            
        case .reposListMoreFetchEnd:
            state.accept(UserDetailState(
                user: current.user,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: current.isLoading,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: false,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: current.canReposListFetchMore,
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
