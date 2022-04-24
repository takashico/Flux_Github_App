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
            isLoading: false,
            apiError: nil
        )
    )
    
    override func onAction(action: Action) {
        let current = state.value
        
        switch action {
        case let action as UserDetailAction.UserDetailFetched:
            state.accept(UserDetailState(
                user: action.user,
                isLoading: false,
                apiError: nil
            ))
            
        case let action as UserDetailAction.ApiError:
            state.accept(UserDetailState(
                user: current.user,
                isLoading: false,
                apiError: action.error
            ))
            
        case _ as UserDetailAction.FirstFetchStart:
            state.accept(UserDetailState(
                user: nil,
                isLoading: true,
                apiError: nil
            ))
            
        case _ as UserDetailAction.FirstFetchEnd:
            state.accept(UserDetailState(
                user: current.user,
                isLoading: false,
                apiError: nil
            ))
            
        default:
            break
        }
    }
}
