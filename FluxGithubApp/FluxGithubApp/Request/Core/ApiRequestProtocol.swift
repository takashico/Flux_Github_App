//
//  ApiRequestProtocol.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import Foundation

protocol ApiRequestProtocol {
    associatedtype Response: Decodable

    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension ApiRequestProtocol {
    var requestUrl: String {
        return "https://api.github.com/" + path
    }
}
