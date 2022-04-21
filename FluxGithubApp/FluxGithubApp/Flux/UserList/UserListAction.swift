//
//  UserListAction.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

enum UserListAction {
    struct FirstFetched: Action {
        var isDataEnded: Bool
        var list: [User]
    }
    
    struct MoreFetched: Action {
        var page: Int
        var isDataEnded: Bool
        var list: [User]
    }
}
