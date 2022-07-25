//
//  User.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

struct User: Decodable, Equatable, Hashable {
    var id: Int
    var name: String
    var avatarUrl: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
    }
}
