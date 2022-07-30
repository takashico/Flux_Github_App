//
//  MockErrorReposRepository.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/30.
//

@testable import FluxGithubApp
import Foundation
import RxSwift

final class MockErrorReposRepositoryImpl: ReposRepository {
    /// ユーザーに紐づくリポジトリ一覧を取得
    func fetchList(username: String, page: Int, perPage: Int) -> Single<[Repos]> {
        Single.create { event in
            event(.failure(URLError(.badURL)))
            return Disposables.create()
        }
    }
}
