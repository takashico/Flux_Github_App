//
//  UserListViewModel.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import RxSwift
import SwiftUI

protocol UserListViewModelInput {
    func fetchUserList()
    func fetchMore()
}

protocol UserListViewModelOutput {
    var list: Observable<[User]> { get }
    var canFetchMore: Observable<Bool> { get }
}

class UserListViewModel: UserListViewModelInput, UserListViewModelOutput {
    private let actionCreator: UserListActionCreator
    private let store: UserListStore
    
    var list: Observable<[User]>
    var canFetchMore: Observable<Bool>
    
    init(actionCreator: UserListActionCreator, store: UserListStore) {
        self.actionCreator = actionCreator
        self.store = store
        
        self.list = store.state.map { state -> [User] in
            state.list
        }
        .share()
        
        self.canFetchMore = store.state.map { state -> Bool in
            state.canFetchMore
        }
        .share()
    }
    
    func fetchUserList() {
        actionCreator.fetchUserList(page: 1)
    }
    
    func fetchMore() {
        let state = store.state.value
        
        // 読み込み中 or すべてのデータ読み込み済み or 初回データ取得未取得
        if state.isLoading || state.isDataEnded || !state.isFirstFetched {
            return
        }
        
        actionCreator.fetchUserList(page: state.page + 1)
    }
}
