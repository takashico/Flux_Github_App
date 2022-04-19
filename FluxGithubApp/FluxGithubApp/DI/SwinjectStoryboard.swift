//
//  SwinjectStoryboard.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/20.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.register(Dispatcher.self) { _ in
            Dispatcher.shared
        }.inObjectScope(.container)
    }
}
