//
//  UserListAction.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

enum UserListAction {
    struct Fetched: Action {
        var list: [User]
    }
}
