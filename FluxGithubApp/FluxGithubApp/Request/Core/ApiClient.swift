//
//  ApiClient.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import Foundation
import RxCocoa
import RxSwift

class ApiClient {
    static let shared = ApiClient()

    private var header: [String: String] = [
        "Accept": "application/vnd.github.v3+json",
        "Authorization": "Bearer \(Environments.GITHUB_PERSONAL_ACCESS_TOKEN)"
    ]

    func sendRequest<Request: ApiRequestProtocol>(request: Request) -> Single<Request.Response> {
        var urlComponents = URLComponents(string: request.requestUrl)
        urlComponents?.queryItems = request.queryItems

        guard let requestUrl = urlComponents?.url else {
            return Single.create { event in
                event(.failure(URLError(.badURL)))
                return Disposables.create()
            }
        }

        var request = URLRequest(url: requestUrl)
        request.allHTTPHeaderFields = header

        return URLSession.shared.rx.data(request: request)
            .map { data -> Request.Response in
                try JSONDecoder().decode(Request.Response.self, from: data)
            }
            .asSingle()
    }
}
