//
//  UserListAction.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

enum UserListAction: Action {
    
    case firstFetched(
        isDataEnded: Bool,
        users: [User]
    )
    case moreFetched(
        isDataEnded: Bool,
        users: [User]
    )
    case apiError(
        error: Error
    )
    case firstFetchStart
    case firstFetchEnd
    case moreFetchStart
    case moreFetchEnd
}
