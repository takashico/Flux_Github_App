//
//  Transitioner.swift
//  FluxGithubApp
//
//  Created by 高橋志昂 on 2022/07/20.
//

import Foundation
import UIKit

protocol Transitioner where Self: UIViewController {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool)
    func popToRootViewController(animated: Bool)
    func popToViewController(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool)
}

extension Transitioner {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let nc = navigationController else {
            assertionFailure("UINavigationControllerが見つからないため無効")
            return
        }
        nc.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool) {
        guard let nc = navigationController else {
            assertionFailure("UINavigationControllerが見つからないため無効")
            return
        }
        nc.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool) {
        guard let nc = navigationController else {
            assertionFailure("UINavigationControllerが見つからないため無効")
            return
        }
        nc.popToRootViewController(animated: animated)
    }

    func popToViewController(_ viewController: UIViewController, animated: Bool) {
        guard let nc = navigationController else {
            assertionFailure("UINavigationControllerが見つからないため無効")
            return
        }
        nc.popToViewController(viewController, animated: animated)
    }

    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        present(viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool) {
        dismiss(animated: animated)
    }
}
