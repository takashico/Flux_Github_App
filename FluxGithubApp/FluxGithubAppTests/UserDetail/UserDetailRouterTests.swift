//
//  UserDetailRouterTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/31.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class UserDetailRouterTests: XCTestCase {
    private struct Dependency {
        let router: UserDetailRouter
        let navigationController: MockNavigationController

        init() {
            navigationController = MockNavigationController()
            let viewController = UIViewController()
            navigationController.viewControllers = [viewController]
            router = UserDetailRouterImpl(view: viewController)
        }
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }

    func testTransitionToRepositoryDetail() {
        // 遷移前であることを確認
        XCTAssertNil(dependency.navigationController.currentVC)

        dependency.router.transitionToRepositoryDetail(
            url: URL(string: Repos.mock1().htmlUrl)!
        )

        // 詳細画面に遷移していることを確認
        XCTAssertTrue(dependency.navigationController.currentVC is RepositoryDetailViewController)
    }
}
