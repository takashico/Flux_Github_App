//
//  MockErrorUserRepositoryImpl.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/29.
//

@testable import FluxGithubApp
import Foundation
import RxSwift

final class MockErrorUserRepositoryImpl: UserRepository {
    /// ユーザー一覧を取得
    func fetchList(since: Int, perPage: Int) -> Single<[User]> {
        Single.create { event in
            event(.failure(URLError(.badURL)))
            return Disposables.create()
        }
    }
    
    /// ユーザー詳細情報を取得
    func fetchDetail(username: String) -> Single<UserDetail> {
        Single.create { event in
            event(.failure(URLError(.badURL)))
            return Disposables.create()
        }
    }
}
