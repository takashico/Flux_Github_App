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
            event(.success([Repos.mock()]))
            return Disposables.create()
        }
    }
}
