//
//  ReposRepository.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import RxSwift

protocol ReposRepository {
    func fetchList(username: String, page: Int, perPage: Int) -> Single<[Repos]>
}

final class ReposRepositoryImpl: ReposRepository {
    private let client: ApiClient
    
    init(apiClient: ApiClient) {
        self.client = apiClient
    }
    
    /// ユーザーに紐づくリポジトリ一覧を取得
    func fetchList(username: String, page: Int, perPage: Int) -> Single<[Repos]> {
        return client.sendRequest(request: FetchReposListRequest(
            username: username,
            page: page,
            perPage: perPage
        ))
    }
}
