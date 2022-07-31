//
//  User.mock.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/27.
//

@testable import FluxGithubApp

extension User {
    static func mock1() -> User {
        User(
            id: 1,
            name: "test1",
            avatarUrl: ""
        )
    }
    
    static func mock2() -> User {
        User(
            id: 2,
            name: "test2",
            avatarUrl: ""
        )
    }
}
