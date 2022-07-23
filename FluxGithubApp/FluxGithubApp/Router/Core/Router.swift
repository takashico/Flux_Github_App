//
//  Router.swift
//  FluxGithubApp
//
//  Created by 高橋志昂 on 2022/07/23.
//

class Router {
    private(set) weak var view: Transitioner!
    
    init(view: Transitioner) {
        self.view = view
    }
}
