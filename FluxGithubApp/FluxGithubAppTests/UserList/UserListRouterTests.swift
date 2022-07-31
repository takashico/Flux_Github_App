//
//  UserListRouterTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/29.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class UserListRouterTests: XCTestCase {
    private struct Dependency {
        let router: UserListRouter
        let navigationController: MockNavigationController
        
        init() {
            navigationController = MockNavigationController()
            let viewController = UIViewController()
            navigationController.viewControllers = [viewController]
            router = UserListRouterImpl(view: viewController)
        }
    }
    
    private var dependency: Dependency!
    
    override func setUp() {
        dependency = Dependency()
    }
    
    func testTransitionToUserDetail() {
        // 初期画面であることを確認
        XCTAssertNil(dependency.navigationController.currentVC)
        
        dependency.router.transitionToUserDetail(username: "test")
        
        // 詳細画面に遷移していることを確認
        XCTAssertTrue(dependency.navigationController.currentVC is UserDetailViewController)
    }
}
