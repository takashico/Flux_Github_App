//
//  UserDetailAction.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

enum UserDetailAction: Action {
    case userDetailFetched(user: UserDetail)
    case reposListFirstFetched(
            reposList: [Repos],
            isDataEnded: Bool
         )
    case reposListMoreFetched(
            page: Int,
            reposList: [Repos],
            isDataEnded: Bool
         )
    case apiError(error: Error)
    case userDetailFetchStart
    case userDetailFetchEnd
    case reposListFirstFetchStart
    case reposListFirstFetchEnd
    case reposListMoreFetchStart
    case reposListMoreFetchEnd
}
