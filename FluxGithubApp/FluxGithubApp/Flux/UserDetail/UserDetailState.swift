//
//  UserDetailState.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

struct UserDetailState: ViewState {
    let user: UserDetail?
    let isLoading: Bool
    let apiError: Error?
}
