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
            let user: User = {
                if since == 0 {
                    return User.mock1()
                } else {
                    return User.mock2()
                }
            }()
            event(.success([user]))
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
