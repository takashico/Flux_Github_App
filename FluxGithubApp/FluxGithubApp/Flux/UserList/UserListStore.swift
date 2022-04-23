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
            users: [],
            isLoading: false,
            isMoreLoading: false,
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
                users: action.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: true,
                isDataEnded: action.isDataEnded,
                canFetchMore: canFetchMore(
                    isMoreLoading: false,
                    isFirstFetched: true,
                    isDataEnded: action.isDataEnded
                )
            ))
            
        case let action as UserListAction.MoreFetched:
            state.accept(UserListState(
                users: current.users + action.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: true,
                isDataEnded: action.isDataEnded,
                canFetchMore: canFetchMore(
                    isMoreLoading: false,
                    isFirstFetched: true,
                    isDataEnded: action.isDataEnded
                )
            ))
            
        case _ as UserListAction.FirstFetchStart:
            state.accept(UserListState(
                users: current.users,
                isLoading: true,
                isMoreLoading: false,
                isFirstFetched: false,
                isDataEnded: current.isDataEnded,
                canFetchMore: false
            ))
            
        case _ as UserListAction.FirstFetchEnd:
            state.accept(UserListState(
                users: current.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: false,
                isDataEnded: current.isDataEnded,
                canFetchMore: current.canFetchMore
            ))
            
        case _ as UserListAction.MoreFetchStart:
            state.accept(UserListState(
                users: current.users,
                isLoading: false,
                isMoreLoading: true,
                isFirstFetched: true,
                isDataEnded: current.isDataEnded,
                canFetchMore: false
            ))
            
        case _ as UserListAction.MoreFetchEnd:
            state.accept(UserListState(
                users: current.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: true,
                isDataEnded: current.isDataEnded,
                canFetchMore: current.canFetchMore
            ))
        default:
            assertionFailure("意図しないアクションの通知を受け取りました。")
        }
    }
    
    private func canFetchMore(isMoreLoading: Bool, isFirstFetched: Bool, isDataEnded: Bool) -> Bool {
        return !isMoreLoading && !isDataEnded && isFirstFetched
    }
}
