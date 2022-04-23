//
//  UserDetail.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

struct UserDetail: Decodable, Equatable, Hashable {
    var id: Int
    var name: String
    var fullName: String
    var avatarUrl: String
    var followerCount: Int
    var followingCount: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    static func == (lhs: UserDetail, rhs: UserDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case fullName = "name"
        case avatarUrl = "avatar_url"
        case followerCount = "followers"
        case followingCount = "following"
    }
}
