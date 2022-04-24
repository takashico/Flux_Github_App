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
        let current = state.value
        
        switch action {
        case let action as UserDetailAction.UserDetailFetched:
            state.accept(UserDetailState(
                user: action.user,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: false,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: current.canReposListFetchMore,
                apiError: nil
            ))
            
        case let action as UserDetailAction.ReposListFirstFetched:
            state.accept(UserDetailState(
                user: current.user,
                reposList: createViewableReposList(reposList: action.reposList),
                reposPage: action.page,
                isLoading: false,
                isReposListFirstFetched: true,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: canReposListFetchMore(
                    isLoading: current.isReposListLoading,
                    isDataEnded: action.isDataEnded,
                    isFirstFetched: true
                ),
                apiError: nil
            ))
            
        case let action as UserDetailAction.ReposListMoreFetched:
            state.accept(UserDetailState(
                user: current.user,
                reposList: current.reposList + createViewableReposList(reposList: action.reposList),
                reposPage: action.page,
                isLoading: false,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: canReposListFetchMore(
                    isLoading: current.isReposListLoading,
                    isDataEnded: action.isDataEnded,
                    isFirstFetched: current.isReposListFirstFetched
                ),
                apiError: nil
            ))
            
        case let action as UserDetailAction.ApiError:
            state.accept(UserDetailState(
                user: current.user,
                reposList: current.reposList,
                reposPage: current.reposPage,
                isLoading: false,
                isReposListFirstFetched: current.isReposListFirstFetched,
                isReposListLoading: current.isReposListLoading,
                isReposListDataEnded: current.isReposListDataEnded,
                canReposListFetchMore: current.canReposListFetchMore,
                apiError: action.error
            ))
            
        case _ as UserDetailAction.UserDetailFetchStart:
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
            
        case _ as UserDetailAction.UserDetailFetchEnd:
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
            
        case _ as UserDetailAction.ReposListFetchStart:
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
            
        case _ as UserDetailAction.ReposListFetchEnd:
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
            
        default:
            break
        }
    }
    
    /// 表示用のReposListを作成（Forkリポジトリを除く処理）
    private func createViewableReposList(reposList: [Repos]) -> [Repos] {
        return reposList.filter { !$0.isFork }
    }
    
    private func canReposListFetchMore(isLoading: Bool, isDataEnded: Bool, isFirstFetched: Bool) -> Bool {
        return !isLoading && !isDataEnded && isFirstFetched
    }
}
