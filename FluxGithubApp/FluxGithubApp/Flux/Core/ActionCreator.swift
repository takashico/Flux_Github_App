//
//  ActionCreator.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/19.
//

import RxSwift

class ActionCreator {
    let disposeBag = DisposeBag()

    private let dispatcher: Dispatcher

    init(_ dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }

    func dispatch(_ action: Action) {
        dispatcher.dispatch(action)
    }
}
