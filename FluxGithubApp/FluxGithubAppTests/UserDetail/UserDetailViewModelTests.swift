//
//  UserDetailViewModelTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/31.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class UserDetailViewModelTests: XCTestCase {
    private struct Dependency {
        let viewModelInput: UserDetailViewModelInput
        let viewModelOutput: UserDetailViewModelOutput
        let navigationController: MockNavigationController
        
        init() {
            let actionCreator = UserDetailActionCreatorImpl(
                .shared,
                userRepository: MockUserRepositoryImpl(),
                reposRepository: MockReposRepositoryImpl()
            )
            let store = UserDetailStoreImpl(.shared)
            let viewModel = UserDetailViewModel(
                actionCreator: actionCreator,
                store: store
            )
            
            navigationController = MockNavigationController()
            let viewController = UIViewController()
            navigationController.viewControllers = [viewController]
            viewModel.injectRouter(
                UserDetailRouterImpl(view: viewController)
            )
            
            viewModelInput = viewModel
            viewModelOutput = viewModel
        }
    }
    
    private let USER_NAME = "test"
    
    private var dependency: Dependency!
    
    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }
    
    func testFetchUserDetail() {
        let result: UserDetail = UserDetail.mock()
        let expect = expectation(description: "wating fetch user detail")
        let disposable = dependency.viewModelOutput.user.subscribe(onNext: { user in
            guard let user = user else { return }
            
            XCTAssertEqual(user.id, result.id)
            expect.fulfill()
        })
        
        dependency.viewModelInput
            .fetchUserDetail(username: USER_NAME)
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
    }
    
    func testFetchReposList() {
        let results: [Repos] = [Repos.mock1()]
        let expect = expectation(description: "wating fetch repos list")
        let disposable = dependency.viewModelOutput.reposList.subscribe(onNext: { reposList in
            guard reposList.isEmpty == false else { return }
            
            XCTAssertEqual(reposList.count, results.count)
            XCTAssertEqual(reposList.first?.id, results.first?.id)
            expect.fulfill()
        })
        
        dependency.viewModelInput
            .fetchReposList(username: USER_NAME)
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
    }
    
    func testFetchMoreReposList() {
        // ???????????????????????????????????????(Repos.mock1()??????????????????????????????)
        dependency.viewModelInput
            .fetchReposList(username: USER_NAME)
        
        let results: [Repos] = [
            Repos.mock1(),
            Repos.mock2()
        ]
        let expect = expectation(description: "wating more fetch repos list")
        let disposable = dependency.viewModelOutput.reposList.subscribe(onNext: { reposList in
            guard reposList.count > results.count - 1 else { return }
            
            XCTAssertEqual(reposList.count, results.count)
            XCTAssertEqual(reposList.last?.id, results.last?.id)
            expect.fulfill()
        })
        
        dependency.viewModelInput
            .fetchMoreReposList(username: USER_NAME)
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
    }
    
    /// ???????????????Cell????????????????????????
    func testDidSelectRepositoryRow() {
        // ?????????????????????????????????
        dependency.viewModelInput
            .fetchReposList(username: USER_NAME)
        
        // ?????????????????????????????????
        XCTAssertNil(dependency.navigationController.currentVC)
        
        dependency.viewModelInput
            .didSelectRepositoryRow(at: IndexPath(row: 0, section: 1))
        
        // ???????????????????????????????????????????????????
        XCTAssertTrue(dependency.navigationController.currentVC is RepositoryDetailViewController)
    }
}
