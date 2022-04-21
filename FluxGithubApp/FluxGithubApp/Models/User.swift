//
//  User.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

struct User: Decodable {
    var id: Int
    var name: String
    var avatarUrl: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
    }
}
