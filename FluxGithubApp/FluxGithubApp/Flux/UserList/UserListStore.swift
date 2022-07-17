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
            canFetchMore: false,
            apiError: nil
        )
    )
    
    override func onAction(action: Action) {
        switch action {
        case let action as UserListAction:
            onAction(action: action)
        default:
            return
        }
    }
}

extension UserListStore {
    private func onAction(action: UserListAction) {
        let current = state.value
        
        switch action {
        case .firstFetched(let isDataEnded, let users):
            state.accept(UserListState(
                users: users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: true,
                isDataEnded: isDataEnded,
                canFetchMore: canFetchMore(
                    isMoreLoading: false,
                    isFirstFetched: true,
                    isDataEnded: isDataEnded
                ),
                apiError: nil
            ))
            
        case .moreFetched(let isDataEnded, let users):
            state.accept(UserListState(
                users: current.users + users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: current.isFirstFetched,
                isDataEnded: isDataEnded,
                canFetchMore: canFetchMore(
                    isMoreLoading: false,
                    isFirstFetched: true,
                    isDataEnded: isDataEnded
                ),
                apiError: nil
            ))
            
        case .apiError(let error):
            state.accept(UserListState(
                users: current.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: true,
                isDataEnded: current.isDataEnded,
                canFetchMore: false,
                apiError: error
            ))
            
        case .firstFetchStart:
            state.accept(UserListState(
                users: current.users,
                isLoading: true,
                isMoreLoading: false,
                isFirstFetched: current.isFirstFetched,
                isDataEnded: current.isDataEnded,
                canFetchMore: false,
                apiError: nil
            ))
            
            
        case .firstFetchEnd:
            state.accept(UserListState(
                users: current.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: current.isFirstFetched,
                isDataEnded: current.isDataEnded,
                canFetchMore: current.canFetchMore,
                apiError: nil
            ))
            
        case .moreFetchStart:
            state.accept(UserListState(
                users: current.users,
                isLoading: false,
                isMoreLoading: true,
                isFirstFetched: true,
                isDataEnded: current.isDataEnded,
                canFetchMore: false,
                apiError: nil
            ))
            
        case .moreFetchEnd:
            state.accept(UserListState(
                users: current.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: true,
                isDataEnded: current.isDataEnded,
                canFetchMore: current.canFetchMore,
                apiError: nil
            ))
        }
    }
    
    private func canFetchMore(isMoreLoading: Bool, isFirstFetched: Bool, isDataEnded: Bool) -> Bool {
        return !isMoreLoading && !isDataEnded && isFirstFetched
    }
}
