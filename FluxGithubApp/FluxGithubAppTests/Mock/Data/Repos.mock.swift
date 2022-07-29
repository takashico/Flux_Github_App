//
//  Repos.mock.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/29.
//

@testable import FluxGithubApp

extension Repos {
    static func mock() -> Repos {
        Repos(
            id: 1,
            name: "test1",
            stargazersCount: 0,
            isFork: false,
            htmlUrl: ""
        )
    }
}
