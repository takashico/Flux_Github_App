//
//  UserListState.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

struct UserListState: ViewState {
    let users: [User]
    let isLoading: Bool
    let isMoreLoading: Bool
    let isFirstFetched: Bool
    let isDataEnded: Bool
    let canFetchMore: Bool
    let apiError: Error?
}
