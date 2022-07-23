//
//  UserListStore.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift
import RxRelay

protocol UserListStore {
    var state: UserListState { get }
    var stateObservable: Observable<UserListState> { get }
}

final class UserListStoreImpl: Store, UserListStore {
    
    private let _state = BehaviorRelay<UserListState>(
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
    
    var state: UserListState {
        return _state.value
    }
    
    var stateObservable: Observable<UserListState> {
        return _state.asObservable()
    }
    
    override func onAction(action: Action) {
        switch action {
        case let action as UserListAction:
            onAction(action: action)
        default:
            return
        }
    }
}

extension UserListStoreImpl {
    private func onAction(action: UserListAction) {
        switch action {
        case .firstFetched(let isDataEnded, let users):
            _state.accept(UserListState(
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
            _state.accept(UserListState(
                users: state.users + users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: state.isFirstFetched,
                isDataEnded: isDataEnded,
                canFetchMore: canFetchMore(
                    isMoreLoading: false,
                    isFirstFetched: true,
                    isDataEnded: isDataEnded
                ),
                apiError: nil
            ))
            
        case .apiError(let error):
            _state.accept(UserListState(
                users: state.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: true,
                isDataEnded: state.isDataEnded,
                canFetchMore: false,
                apiError: error
            ))
            
        case .firstFetchStart:
            _state.accept(UserListState(
                users: state.users,
                isLoading: true,
                isMoreLoading: false,
                isFirstFetched: state.isFirstFetched,
                isDataEnded: state.isDataEnded,
                canFetchMore: false,
                apiError: nil
            ))
            
            
        case .firstFetchEnd:
            _state.accept(UserListState(
                users: state.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: state.isFirstFetched,
                isDataEnded: state.isDataEnded,
                canFetchMore: state.canFetchMore,
                apiError: nil
            ))
            
        case .moreFetchStart:
            _state.accept(UserListState(
                users: state.users,
                isLoading: false,
                isMoreLoading: true,
                isFirstFetched: true,
                isDataEnded: state.isDataEnded,
                canFetchMore: false,
                apiError: nil
            ))
            
        case .moreFetchEnd:
            _state.accept(UserListState(
                users: state.users,
                isLoading: false,
                isMoreLoading: false,
                isFirstFetched: true,
                isDataEnded: state.isDataEnded,
                canFetchMore: state.canFetchMore,
                apiError: nil
            ))
        }
    }
    
    private func canFetchMore(isMoreLoading: Bool, isFirstFetched: Bool, isDataEnded: Bool) -> Bool {
        return !isMoreLoading && !isDataEnded && isFirstFetched
    }
}
