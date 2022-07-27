//
//  UserListActionCreatorTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/27.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

class UserListActionCreatorTests: XCTestCase {
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
        let resultUsers: [User] = [User.mock1()]
        let expect = expectation(description: "waiting UserListAction.firstFetched")
        
        let disposable = dependency.dispatcher.register { action in
            switch action as? UserListAction {
            case let .firstFetched(_, users):
                XCTAssertEqual(users, resultUsers)
                expect.fulfill()
            default:
                break
            }
        }
        
        dependency.actionCreator.firstFetchUserList(perPage: 2)
        
        wait(for: [expect], timeout: 1.0)
        
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
        let resultUsers: [User] = [User.mock2()]
        let expect = expectation(description: "waiting UserListAction.moreFetched")
        
        let disposable = dependency.dispatcher.register { action in
            switch action as? UserListAction {
            case let .moreFetched(_, users):
                XCTAssertEqual(users, resultUsers)
                expect.fulfill()
            default:
                break
            }
        }
        
        dependency.actionCreator.moreFetchUserList(since: 1, perPage: 2)
        
        wait(for: [expect], timeout: 1.0)
        
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
