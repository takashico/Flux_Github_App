//
//  UserListRouter.swift
//  FluxGithubApp
//
//  Created by 高橋志昂 on 2022/07/21.
//

protocol UserListRouter {
    func transitionToUserDetail(username: String)
}

final class UserListRouterImpl: Router, UserListRouter {
    func transitionToUserDetail(username: String) {
        let viewController = UserDetailViewController.instantiate()
        viewController.username = username
        view.pushViewController(viewController, animated: true)
    }
}
