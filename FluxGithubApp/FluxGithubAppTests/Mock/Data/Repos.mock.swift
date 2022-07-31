//
//  Repos.mock.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/29.
//

@testable import FluxGithubApp

extension Repos {
    static func mock1() -> Repos {
        Repos(
            id: 1,
            name: "test1",
            stargazersCount: 0,
            isFork: false,
            htmlUrl: ""
        )
    }
    
    static func mock2() -> Repos {
        Repos(
            id: 2,
            name: "test2",
            stargazersCount: 0,
            isFork: false,
            htmlUrl: ""
        )
    }
    
    // isFork = trueであるモック
    static func forkMock() -> Repos {
        Repos(
            id: 1,
            name: "test1",
            stargazersCount: 0,
            isFork: true,
            htmlUrl: ""
        )
    }
}
