//
//  MockUserRepositoryImpl.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/26.
//

@testable import FluxGithubApp
import RxSwift

final class MockUserRepositoryImpl: UserRepository {
    /// ユーザー一覧を取得
    func fetchList(since: Int, perPage: Int) -> Single<[User]> {
        Single.create { event in
            if since == 0 {
                event(.success([User.mock1()]))
            } else {
                event(.success([User.mock2()]))
            }
            return Disposables.create()
        }
    }
    
    /// ユーザー詳細情報を取得
    func fetchDetail(username: String) -> Single<UserDetail> {
        Single.create { event in
            event(.success(UserDetail.mock()))
            return Disposables.create()
        }
    }
}
