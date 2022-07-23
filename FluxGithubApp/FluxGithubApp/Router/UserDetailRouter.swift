//
//  UserDetailRouter.swift
//  FluxGithubApp
//
//  Created by 高橋志昂 on 2022/07/23.
//

import Foundation

protocol UserDetailRouter {
    func transitionToRepositoryDetail(url: URL)
}

final class UserDetailRouterImpl: Router, UserDetailRouter {
    func transitionToRepositoryDetail(url: URL) {
        let viewController = RepositoryDetailViewController()
        viewController.url = url
        view.pushViewController(viewController, animated: true)
    }
}
