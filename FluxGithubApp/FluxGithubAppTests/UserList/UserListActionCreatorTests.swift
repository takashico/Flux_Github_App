//
//  UserListActionCreatorTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/27.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class UserListActionCreatorTests: XCTestCase {
    private struct Dependency {
        let actionCreator: UserListActionCreator
        let errorActionCreator: UserListActionCreator
        let dispatcher: Dispatcher

        init() {
            dispatcher = .shared
            actionCreator = UserListActionCreatorImpl(
                dispatcher,
                userRepository: MockUserRepositoryImpl()
            )
            errorActionCreator = UserListActionCreatorImpl(
                dispatcher,
                userRepository: MockErrorUserRepositoryImpl()
            )
        }
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }

    func testFirstFetchUserList() {
        let fetchedExpect = expectation(description: "waiting UserListAction.firstFetched")
        let fetchStartExpect = expectation(description: "waiting UserListAction.firstFetchStart")
        let fetchEndExpect = expectation(description: "waiting UserListAction.firstFetchEnd")

        let disposable = dependency.dispatcher.register { action in
            switch action as? UserListAction {
            case let .firstFetched(_, users):
                let resultUsers: [User] = [User.mock1()]
                XCTAssertEqual(users.count, resultUsers.count)
                XCTAssertEqual(users.first?.id, resultUsers.first?.id)
                fetchedExpect.fulfill()
            case .firstFetchStart:
                fetchStartExpect.fulfill()
            case .firstFetchEnd:
                fetchEndExpect.fulfill()
            default:
                break
            }
        }

        dependency.actionCreator.firstFetchUserList(perPage: 2)

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

    func testErrorFirstFetchUserList() {
        var fetchedError: Error?
        let expect = expectation(description: "waiting UserListAction.apiError")

        let disposable = dependency.dispatcher.register { action in
            switch action as? UserListAction {
            case let .apiError(error):
                fetchedError = error
                expect.fulfill()
            default:
                break
            }
        }

        dependency.errorActionCreator.firstFetchUserList(perPage: 2)

        wait(for: [expect], timeout: 1.0)
        XCTAssertNotNil(fetchedError)

        disposable.dispose()
    }

    func testMoreFetchUserList() {
        let fetchedExpect = expectation(description: "waiting UserListAction.moreFetched")
        let fetchStartExpect = expectation(description: "waiting UserListAction.moreFetchStart")
        let fetchEndExpect = expectation(description: "waiting UserListAction.moreFetchEnd")

        let disposable = dependency.dispatcher.register { action in
            switch action as? UserListAction {
            case let .moreFetched(_, users):
                let resultUsers: [User] = [User.mock2()]
                XCTAssertEqual(users.count, resultUsers.count)
                XCTAssertEqual(users.first?.id, resultUsers.first?.id)
                fetchedExpect.fulfill()
            case .moreFetchStart:
                fetchStartExpect.fulfill()
            case .moreFetchEnd:
                fetchEndExpect.fulfill()
            default:
                break
            }
        }

        dependency.actionCreator.moreFetchUserList(since: 1, perPage: 2)

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

    func testErrorMoreFetchUserList() {
        var fetchedError: Error?
        let expect = expectation(description: "waiting UserListAction.apiError")

        let disposable = dependency.dispatcher.register { action in
            switch action as? UserListAction {
            case let .apiError(error):
                fetchedError = error
                expect.fulfill()
            default:
                break
            }
        }

        dependency.errorActionCreator.moreFetchUserList(since: 1, perPage: 2)

        wait(for: [expect], timeout: 1.0)
        XCTAssertNotNil(fetchedError)

        disposable.dispose()
    }
}
