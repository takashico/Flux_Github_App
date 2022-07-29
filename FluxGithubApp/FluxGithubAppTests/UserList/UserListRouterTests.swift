//
//  UserListRouterTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/29.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class MockNavigationController: UINavigationController {
    var currentVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        currentVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

final class MockViewController: UIViewController {}

class UserListRouterTests: XCTestCase {
    private struct Dependency {
        var router: UserListRouter
        var navigationController: MockNavigationController
        
        init() {
            let viewController = UIViewController()
            navigationController = MockNavigationController()
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
