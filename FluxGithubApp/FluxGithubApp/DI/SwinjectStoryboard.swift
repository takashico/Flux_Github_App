//
//  SwinjectStoryboard.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/20.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        // API Client
        defaultContainer.register(ApiClient.self) { _ in
            ApiClient.shared
        }
        .inObjectScope(.container)
        
        // Repositories
        defaultContainer.register(UserRepository.self) { r in
            UserRepositoryImpl(apiClient: r.resolve(ApiClient.self)!)
        }
        .inObjectScope(.container)
        
        // Dispatch
        defaultContainer.register(Dispatcher.self) { _ in
            Dispatcher.shared
        }
        .inObjectScope(.container)
        
        // Store
        defaultContainer.register(UserListStore.self) { r in
            UserListStore(r.resolve(Dispatcher.self)!)
        }
        .inObjectScope(.container)
        
        // ActionCreator
        defaultContainer.register(UserListActionCreator.self) { r in
            UserListActionCreator(
                r.resolve(Dispatcher.self)!,
                userRepository: r.resolve(UserRepository.self)!
            )
        }
        .inObjectScope(.container)
        
        // ViewModel
        defaultContainer.register(UserListViewModel.self) { r in
            UserListViewModel(
                actionCreator: r.resolve(UserListActionCreator.self)!,
                store: r.resolve(UserListStore.self)!
            )
        }
        .inObjectScope(.container)
        
        // ViewController
        defaultContainer.storyboardInitCompleted(UserListViewController.self) { r, c in
            c.viewModelInput = r.resolve(UserListViewModel.self)
            c.viewModelOutput = r.resolve(UserListViewModel.self)
        }
    }
}
