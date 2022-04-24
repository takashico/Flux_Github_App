//
//  UserDetailAction.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

enum UserDetailAction {
    struct UserDetailFetched: Action {
        var user: UserDetail
    }
    
    struct FirstFetchStart: Action { }
    
    struct FirstFetchEnd: Action { }
    
    struct ApiError: Action {
        var error: Error
    }
}

