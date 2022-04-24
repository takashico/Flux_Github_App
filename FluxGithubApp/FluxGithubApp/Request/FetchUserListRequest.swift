//
//  FetchUserListRequest.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import Foundation

struct FetchUserListRequest: ApiRequestProtocol {
    typealias Response = [User]
    
    init(since: Int, perPage: Int) {
        queryItems = [
            URLQueryItem(name: "since", value: "\(since)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
    }
    
    var path: String = "users"
    var queryItems: [URLQueryItem]?
}
