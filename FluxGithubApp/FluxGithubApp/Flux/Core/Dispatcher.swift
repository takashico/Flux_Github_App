//
//  Dispatcher.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/19.
//

import RxSwift
import RxRelay

final class Dispatcher {
    static let shared = Dispatcher()
    
    private let _action = PublishRelay<Action>()
    
    func register(callback: @escaping (Action) -> ()) -> Disposable {
        return _action.subscribe(onNext: callback)
    }
    
    func dispatch(_ action: Action) {
        _action.accept(action)
    }
}
