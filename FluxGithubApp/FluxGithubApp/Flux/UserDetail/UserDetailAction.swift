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
    
    struct ReposListFirstFetched: Action {
        var page: Int
        var reposList: [Repos]
        var isDataEnded: Bool
    }
    
    struct ReposListMoreFetched: Action {
        var page: Int
        var reposList: [Repos]
        var isDataEnded: Bool
    }
    
    struct UserDetailFetchStart: Action { }
    
    struct UserDetailFetchEnd: Action { }
    
    struct ReposListFetchStart: Action { }
    
    struct ReposListFetchEnd: Action { }
    
    struct ApiError: Action {
        var error: Error
    }
}

