//
//  UserRepository.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift

protocol UserRepository {
    func fetchList(page: Int, perPage: Int) -> Single<[User]>
}

final class UserRepositoryImpl: UserRepository {
    private let client: ApiClient
    
    init(apiClient: ApiClient) {
        self.client = apiClient
    }
    
    /// ユーザー一覧を取得
    func fetchList(page: Int, perPage: Int) -> Single<[User]> {
        return client.fetchUserList(page: page, perPage: perPage)
    }
}
