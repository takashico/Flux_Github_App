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
    
    func fetchUserList() -> Single<([User])> {
        var request = URLRequest(url: URL(string: "https://api.github.com/users")!)
        request.allHTTPHeaderFields = self.header
        
        return URLSession.shared.rx.data(request: request)
            .map { data -> [User] in
                return try JSONDecoder().decode([User].self, from: data)
            }
            .asSingle()
    }
}
