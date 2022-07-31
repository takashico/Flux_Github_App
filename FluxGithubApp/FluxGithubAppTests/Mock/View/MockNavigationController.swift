//
//  MockNavigationController.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/31.
//

import UIKit

final class MockNavigationController: UINavigationController {
    var currentVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        currentVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
