//
//  FetchUserDetailRequest.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import Foundation

struct FetchUserDetailRequest: ApiRequestProtocol {
    typealias Response = UserDetail
    
    init(username: String) {
        path = "users/\(username)"
    }
    
    var path: String
    var queryItems: [URLQueryItem]? = nil
}
