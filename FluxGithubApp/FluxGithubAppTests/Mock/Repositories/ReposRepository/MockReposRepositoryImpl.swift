//
//  MockReposRepositoryImpl.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/29.
//

@testable import FluxGithubApp
import RxSwift

final class MockReposRepositoryImpl: ReposRepository {
    /// ユーザーに紐づくリポジトリ一覧を取得
    func fetchList(username: String, page: Int, perPage: Int) -> Single<[Repos]> {
        Single.create { event in
            let repos: Repos = {
                if page <= 1 {
                    return Repos.mock1()
                } else {
                    return Repos.mock2()
                }
            }()
            event(.success([repos]))
            return Disposables.create()
        }
    }
}
