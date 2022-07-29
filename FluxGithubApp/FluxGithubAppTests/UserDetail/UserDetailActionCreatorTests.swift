//
//  UserDetailActionCreatorTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/29.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class UserDetailActionCreatorTests: XCTestCase {
    private struct Dependency {
        var actionCreator: UserDetailActionCreator
        var dispatcher: Dispatcher
        
        init() {
            dispatcher = .shared
            actionCreator = UserDetailActionCreatorImpl(
                dispatcher,
                userRepository: MockUserRepositoryImpl(),
                reposRepository: MockReposRepositoryImpl()
            )
        }
    }
    
    private var dependency: Dependency!
    
    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }
    
    func testFetchUserDetail() {
        // 期待する取得データ
        let results: UserDetail = UserDetail.mock()
        
        let fetchedExpect = expectation(description: "waiting UserDetailAction.userDetailFetched")
        let fetchStartExpect = expectation(description: "waiting UserDetailAction.userDetailFetchStart")
        let fetchEndExpect = expectation(description: "waiting UserDetailAction.userDetailFetchEnd")
        
        let disposable = dependency.dispatcher.register { action in
            switch action as? UserDetailAction {
            case let .userDetailFetched(user):
                XCTAssertEqual(user.id, results.id)
                fetchedExpect.fulfill()
            case .userDetailFetchStart:
                fetchStartExpect.fulfill()
            case.userDetailFetchEnd:
                fetchEndExpect.fulfill()
            default:
                break
            }
        }
        
        dependency.actionCreator.fetchUserDetail(username: "test")
        
        wait(
            for: [
                fetchStartExpect,
                fetchEndExpect,
                fetchedExpect
            ],
            timeout: 1.0,
            enforceOrder: true
        )
        
        disposable.dispose()
    }
}
