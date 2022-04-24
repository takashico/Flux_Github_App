//
//  FetchReposListRequest.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import Foundation

struct FetchReposListRequest: ApiRequestProtocol {
    typealias Response = [Repos]
    
    init(username: String, page: Int, perPage: Int) {
        path = "users/\(username)/repos"
        queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
    }
    
    var path: String
    var queryItems: [URLQueryItem]?
}
