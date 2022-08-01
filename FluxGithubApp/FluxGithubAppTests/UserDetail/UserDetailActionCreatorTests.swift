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
        let actionCreator: UserDetailActionCreator
        let errorActionCreator: UserDetailActionCreator
        let dispatcher: Dispatcher

        init() {
            dispatcher = .shared
            actionCreator = UserDetailActionCreatorImpl(
                dispatcher,
                userRepository: MockUserRepositoryImpl(),
                reposRepository: MockReposRepositoryImpl()
            )
            errorActionCreator = UserDetailActionCreatorImpl(
                dispatcher,
                userRepository: MockErrorUserRepositoryImpl(),
                reposRepository: MockErrorReposRepositoryImpl()
            )
        }
    }

    private let USER_NAME = "test"
    private let PER_PAGE = 20
    private let MORE_PAGE = 2

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }

    func testFetchUserDetail() {
        let fetchedExpect = expectation(description: "waiting UserDetailAction.userDetailFetched")
        let fetchStartExpect = expectation(description: "waiting UserDetailAction.userDetailFetchStart")
        let fetchEndExpect = expectation(description: "waiting UserDetailAction.userDetailFetchEnd")

        let disposable = dependency.dispatcher.register { action in
            switch action as? UserDetailAction {
            case let .userDetailFetched(user):
                // 期待する結果
                let result: UserDetail = .mock()
                XCTAssertEqual(user.id, result.id)
                fetchedExpect.fulfill()
            case .userDetailFetchStart:
                fetchStartExpect.fulfill()
            case .userDetailFetchEnd:
                fetchEndExpect.fulfill()
            default:
                break
            }
        }

        dependency.actionCreator
            .fetchUserDetail(username: USER_NAME)

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

    func testFirstFetchUserRepositories() {
        let fetchedExpect = expectation(description: "waiting UserDetailAction.reposListFirstFetched")
        let fetchStartExpect = expectation(description: "waiting UserDetailAction.reposListFirstFetchStart")
        let fetchEndExpect = expectation(description: "waiting UserDetailAction.reposListFirstFetchEnd")

        let disposable = dependency.dispatcher.register { action in
            switch action as? UserDetailAction {
            case let .reposListFirstFetched(reposList, _):
                // 期待する結果
                let results: [Repos] = [Repos.mock1()]
                XCTAssertEqual(reposList.count, results.count)
                XCTAssertEqual(reposList.first?.id, results.first?.id)
                fetchedExpect.fulfill()
            case .reposListFirstFetchStart:
                fetchStartExpect.fulfill()
            case .reposListFirstFetchEnd:
                fetchEndExpect.fulfill()
            default:
                break
            }
        }

        dependency.actionCreator
            .firstFetchUserRepositories(username: USER_NAME, perPage: PER_PAGE)

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

    func testMoreFetchUserRepositories() {
        let fetchedExpect = expectation(description: "waiting UserDetailAction.reposListMoreFetched")
        let fetchStartExpect = expectation(description: "waiting UserDetailAction.reposListMoreFetchStart")
        let fetchEndExpect = expectation(description: "waiting UserDetailAction.reposListMoreFetchEnd")

        let disposable = dependency.dispatcher.register { [weak self] action in
            switch action as? UserDetailAction {
            case let .reposListMoreFetched(page, reposList, _):
                // 期待する結果
                let results: [Repos] = [Repos.mock2()]
                XCTAssertEqual(reposList.count, results.count)
                XCTAssertEqual(reposList.first?.id, results.first?.id)

                XCTAssertEqual(page, self?.MORE_PAGE)
                fetchedExpect.fulfill()
            case .reposListMoreFetchStart:
                fetchStartExpect.fulfill()
            case .reposListMoreFetchEnd:
                fetchEndExpect.fulfill()
            default:
                break
            }
        }

        dependency.actionCreator
            .moreFetchUserRepositories(
                username: USER_NAME,
                page: MORE_PAGE,
                perPage: PER_PAGE
            )

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

    /// APIError時のテスト
    func testApiError() {
        var fetchedError: Error?
        let expect = expectation(description: "waiting UserDetailAction.apiError")
        // 3回分テストを行う
        expect.expectedFulfillmentCount = 3

        let disposable = dependency.dispatcher.register { action in
            switch action as? UserDetailAction {
            case let .apiError(error):
                fetchedError = error
                expect.fulfill()
            default:
                break
            }
        }

        dependency.errorActionCreator
            .fetchUserDetail(username: USER_NAME)
        dependency.errorActionCreator
            .firstFetchUserRepositories(username: USER_NAME, perPage: PER_PAGE)
        dependency.errorActionCreator
            .moreFetchUserRepositories(username: USER_NAME, page: MORE_PAGE, perPage: PER_PAGE)

        wait(for: [expect], timeout: 1.0)
        XCTAssertNotNil(fetchedError)

        disposable.dispose()
    }
}
