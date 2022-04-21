//
//  UserListState.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

struct UserListState: ViewState {
    let list: [User]
    let page: Int
    let isLoading: Bool
    let isFirstFetched: Bool
    let isDataEnded: Bool
    let canFetchMore: Bool
}
