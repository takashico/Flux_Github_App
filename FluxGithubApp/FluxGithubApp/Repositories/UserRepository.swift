//
//  UserRepository.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift

protocol UserRepository {
    func fetchList(since: Int, perPage: Int) -> Single<[User]>
    func fetchDetail(username: String) -> Single<UserDetail>
}

final class UserRepositoryImpl: UserRepository {
    private let client: ApiClient

    init(apiClient: ApiClient) {
        self.client = apiClient
    }

    /// ユーザー一覧を取得
    func fetchList(since: Int, perPage: Int) -> Single<[User]> {
        return client.sendRequest(request: FetchUserListRequest(
            since: since,
            perPage: perPage
        ))
    }

    /// ユーザー詳細情報を取得
    func fetchDetail(username: String) -> Single<UserDetail> {
        return client.sendRequest(request: FetchUserDetailRequest(
            username: username
        ))
    }
}
