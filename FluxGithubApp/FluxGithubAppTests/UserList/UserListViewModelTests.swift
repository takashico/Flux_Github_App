//
//  UserListViewModelTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/28.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class UserListViewModelTests: XCTestCase {
    private struct Dependency {
        let viewModelInput: UserListViewModelInput
        let viewModelOutput: UserListViewModelOutput
        let navigationController: MockNavigationController
        
        init() {
            let actionCreator = UserListActionCreatorImpl(
                .shared,
                userRepository: MockUserRepositoryImpl()
            )
            let store = UserListStoreImpl(.shared)
            
            let viewModel = UserListViewModel(
                actionCreator: actionCreator,
                store: store
            )
            
            navigationController = MockNavigationController()
            let viewController = UIViewController()
            navigationController.viewControllers = [viewController]
            viewModel.injectRouter(
                UserListRouterImpl(view: viewController)
            )
            
            viewModelInput = viewModel
            viewModelOutput = viewModel
        }
    }
    
    private var dependency: Dependency!
    
    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }
    
    func testFetchUserList() {
        let results: [User] = [User.mock1()]
        
        let expect = expectation(description: "waiting fetch user list")
        let disposable = dependency.viewModelOutput.users.subscribe(onNext: { users in
            guard users.isEmpty == false else { return }
            
            XCTAssertEqual(users.count, results.count)
            XCTAssertEqual(users.first?.id, results.first?.id)
            expect.fulfill()
        })
        
        dependency.viewModelInput.fetchUserList()
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
    }
    
    func testFetchMore() {
        // 初回データを取得する
        dependency.viewModelInput.fetchUserList()
        
        let results: [User] = [
            User.mock1(),
            User.mock2()
        ]
        
        let expect = expectation(description: "waiting fetch more user list")
        let disposable = dependency.viewModelOutput.users.subscribe(onNext: { users in
            guard users.count >= results.count else { return }
            
            XCTAssertEqual(users.count, results.count)
            XCTAssertEqual(users.last?.id, results.last?.id)
            expect.fulfill()
        })
        
        dependency.viewModelInput.fetchMore()
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
    }
    
    /// ユーザーCellのタップアクション
    func testDidSelectRow() {
        // データを取得済みにする
        dependency.viewModelInput.fetchUserList()
        
        // 遷移前であることを確認
        XCTAssertNil(dependency.navigationController.currentVC)
        
        dependency.viewModelInput
            .didSelectRow(at: IndexPath(row: 0, section: 0))
        
        // 詳細画面に遷移できていることを確認
        XCTAssertTrue(dependency.navigationController.currentVC is UserDetailViewController)
    }
}
