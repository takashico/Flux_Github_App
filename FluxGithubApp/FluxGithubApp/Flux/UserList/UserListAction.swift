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
    
    struct MoreFetchedStart: Action { }
    
    struct MoreFetchedEnd: Action { }
}
