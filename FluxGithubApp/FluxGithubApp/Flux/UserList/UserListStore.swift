//
//  UserListStore.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift
import RxRelay

final class UserListStore: Store {
    
    let state = BehaviorRelay<UserListState>(
        value: UserListState(
            list: [],
            page: 1,
            isLoading: false,
            isFirstFetched: false,
            isDataEnded: false,
            canFetchMore: false
        )
    )
    
    override func onAction(action: Action) {
        let current = state.value
        
        switch action {
        case let action as UserListAction.FirstFetched:
            state.accept(UserListState(
                list: action.list,
                page: 1,
                isLoading: false,
                isFirstFetched: true,
                isDataEnded: action.isDataEnded,
                canFetchMore: canFetchMore(
                    isLoading: false,
                    isFirstFetched: true,
                    isDataEnded: action.isDataEnded
                )
            ))
            
        case let action as UserListAction.MoreFetched:
            state.accept(UserListState(
                list: current.list + action.list,
                page: action.page,
                isLoading: false,
                isFirstFetched: true,
                isDataEnded: action.isDataEnded,
                canFetchMore: canFetchMore(
                    isLoading: false,
                    isFirstFetched: true,
                    isDataEnded: action.isDataEnded
                )
            ))
        default:
            assertionFailure("意図しないアクションの通知を受け取りました。")
        }
    }
    
    private func canFetchMore(isLoading: Bool, isFirstFetched: Bool, isDataEnded: Bool) -> Bool {
        return !isLoading && !isDataEnded && isFirstFetched
    }
}
