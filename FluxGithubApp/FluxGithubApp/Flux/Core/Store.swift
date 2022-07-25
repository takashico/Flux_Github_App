//
//  Store.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/19.
//

import RxSwift

class Store {
    private let disposeBag = DisposeBag()

    init(_ dispatcher: Dispatcher) {
        dispatcher.register { [weak self] action in
            guard let strongSelf = self else { return }

            strongSelf.onAction(action: action)
        }
        .disposed(by: disposeBag)
    }

    func onAction(action: Action) {}
}
