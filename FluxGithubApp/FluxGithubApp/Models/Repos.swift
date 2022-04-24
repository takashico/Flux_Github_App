//
//  Repos.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

struct Repos: Decodable, Equatable, Hashable {
    var id: Int
    var name: String
    var description: String?
    var language: String?
    var stargazersCount: Int
    var isFork: Bool
    var htmlUrl: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    static func == (lhs: Repos, rhs: Repos) -> Bool {
        return lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case stargazersCount = "stargazers_count"
        case isFork = "fork"
        case htmlUrl = "html_url"
    }
}
