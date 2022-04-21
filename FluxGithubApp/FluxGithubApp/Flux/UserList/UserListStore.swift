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
            list: []
        )
    )
    
    override func onAction(action: Action) {
        switch action {
        case let action as UserListAction.Fetched:
            state.accept(UserListState(
                list: action.list
            ))
        default:
            assertionFailure("意図しないアクションの通知を受け取りました。")
        }
    }
}
