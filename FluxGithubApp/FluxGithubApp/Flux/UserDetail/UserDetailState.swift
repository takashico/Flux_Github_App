//
//  UserDetailState.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

struct UserDetailState: ViewState {
    let user: UserDetail?
    let reposList: [Repos]
    let reposPage: Int
    let isLoading: Bool
    let isReposListFirstFetched: Bool
    let isReposListLoading: Bool
    let isReposListDataEnded: Bool
    let canReposListFetchMore: Bool
    let apiError: Error?
}
