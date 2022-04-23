//
//  UserListAction.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

enum UserListAction {
    struct FirstFetched: Action {
        var isDataEnded: Bool
        var users: [User]
    }
    
    struct MoreFetched: Action {
        var isDataEnded: Bool
        var users: [User]
    }
    
    struct FirstFetchStart: Action { }
    
    struct FirstFetchEnd: Action { }
    
    struct MoreFetchStart: Action { }
    
    struct MoreFetchEnd: Action { }
    
    struct ApiError: Action {
        var error: Error
    }
}
