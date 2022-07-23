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
        
        defaultContainer.register(ReposRepository.self) { r in
            ReposRepositoryImpl(apiClient: r.resolve(ApiClient.self)!)
        }
        .inObjectScope(.container)
        
        // Dispatch
        defaultContainer.register(Dispatcher.self) { _ in
            Dispatcher.shared
        }
        .inObjectScope(.container)
        
        // Store
        defaultContainer.register(UserListStore.self) { r in
            UserListStoreImpl(r.resolve(Dispatcher.self)!)
        }
        .inObjectScope(.container)
        
        defaultContainer.register(UserDetailStore.self) { r in
            UserDetailStore(r.resolve(Dispatcher.self)!)
        }
        .inObjectScope(.container)
        
        // ActionCreator
        defaultContainer.register(UserListActionCreator.self) { r in
            UserListActionCreatorImpl(
                r.resolve(Dispatcher.self)!,
                userRepository: r.resolve(UserRepository.self)!
            )
        }
        .inObjectScope(.container)
        
        defaultContainer.register(UserDetailActionCreator.self) { r in
            UserDetailActionCreator(
                r.resolve(Dispatcher.self)!,
                userRepository: r.resolve(UserRepository.self)!,
                reposRepository: r.resolve(ReposRepository.self)!
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
        
        defaultContainer.register(UserDetailViewModel.self) { r in
            UserDetailViewModel(
                actionCreator: r.resolve(UserDetailActionCreator.self)!,
                store: r.resolve(UserDetailStore.self)!
            )
        }
        
        // ViewController
        defaultContainer.storyboardInitCompleted(UserListViewController.self) { r, c in
            let viewModel = r.resolve(UserListViewModel.self)
            viewModel?.injectRouter(UserListRouterImpl(view: c))
            c.viewModelInput = viewModel
            c.viewModelOutput = viewModel
        }
        
        defaultContainer.storyboardInitCompleted(UserDetailViewController.self) { r, c in
            let viewModel = r.resolve(UserDetailViewModel.self)
            viewModel?.injectRouter(UserDetailRouterImpl(view: c))
            c.viewModelInput = viewModel
            c.viewModelOutput = viewModel
        }
    }
}
