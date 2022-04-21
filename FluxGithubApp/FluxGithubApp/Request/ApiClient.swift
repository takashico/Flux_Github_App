//
//  ApiClient.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift
import RxCocoa
import Foundation

class ApiClient {
    static let shared = ApiClient()
    
    private var header: [String: String] = [
        "Accept": "application/vnd.github.v3+json",
        "Authorization": "Bearer \(Environments.GITHUB_PERSONAL_ACCESS_TOKEN)"
    ]
    
    func fetchUserList(page: Int, perPage: Int) -> Single<([User])> {
        var urlComponents = URLComponents(string: "https://api.github.com/users")
        let since: Int = (page - 1) * perPage
        urlComponents?.queryItems = [
            URLQueryItem(name: "since", value: "\(since)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let requestUrl = urlComponents?.url else {
            return Single.create { event in
                event(.failure(URLError(.badURL)))
                return Disposables.create()
            }
        }
        
        var request = URLRequest(url: requestUrl)
        request.allHTTPHeaderFields = self.header
        
        return URLSession.shared.rx.data(request: request)
            .map { data -> [User] in
                return try JSONDecoder().decode([User].self, from: data)
            }
            .asSingle()
    }
}
