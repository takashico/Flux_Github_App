//
//  UserDetail.mock.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/27.
//

@testable import FluxGithubApp

extension UserDetail {
    static func mock() -> UserDetail {
        UserDetail(
            id: 1,
            name: "test",
            avatarUrl: "",
            followerCount: 0,
            followingCount: 0
        )
    }
}
