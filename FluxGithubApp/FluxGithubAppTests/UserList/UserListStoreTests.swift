//
//  UserListStoreTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/28.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class UserListStoreTests: XCTestCase {
    private struct Dependency {
        let store: UserListStore
        let dispatcher: Dispatcher
        
        init() {
            dispatcher = .shared
            store = UserListStoreImpl(dispatcher)
        }
    }
    
    private var dependency: Dependency!
    private var store: UserListStore {
        dependency.store
    }
    
    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }
    
    func testFirstFetchedUsers() {
        // 初期値であることを確認
        XCTAssertTrue(store.state.users.isEmpty)
        XCTAssertFalse(store.state.isDataEnded)
        // 期待する結果
        let results: [User] = [User.mock1()]
        
        let expect = expectation(description: "state changes by UserListAction.firstFetched")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard !state.users.isEmpty else { return }
            // 更新されたstateが想定通りであることを確認
            XCTAssertEqual(state.users.count, results.count)
            XCTAssertEqual(state.users.first?.id, results.first?.id)
            XCTAssertTrue(state.isDataEnded)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserListAction.firstFetched(
                isDataEnded: true,
                users: results
            )
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertEqual(store.state.users.count, results.count)
        XCTAssertEqual(store.state.users.first?.id, results.first?.id)
        XCTAssertTrue(store.state.isDataEnded)
    }
    
    /// 取得済みデータがある状態でデータ追加ができるのかを確認する
    func testMoreFetchedUsers() {
        // 初回データを流す(User.mock1()のみ)
        dependency.dispatcher.dispatch(
            UserListAction.firstFetched(
                isDataEnded: false,
                users: [User.mock1()]
            )
        )
        
        // 期待する結果
        let results: [User] = [
            User.mock1(),
            User.mock2()
        ]
        
        let expect = expectation(description: "state changes by UserListAction.moreFetched")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.users.count > 1 else { return }
            // 更新されたstateが想定通りであることを確認
            XCTAssertEqual(state.users.count, results.count)
            XCTAssertEqual(state.users.last?.id, results.last?.id)
            XCTAssertTrue(state.isDataEnded)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す(User.mock2()のみ)
        dependency.dispatcher.dispatch(
            UserListAction.moreFetched(
                isDataEnded: true,
                users: [User.mock2()]
            )
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertEqual(store.state.users.count, results.count)
        XCTAssertEqual(store.state.users.last?.id, results.last?.id)
        XCTAssertTrue(store.state.isDataEnded)
    }
    
    /// ローディングの開始の状態を確認する
    func testFirstFetchStart() {
        // 初期値であることを確認
        XCTAssertFalse(store.state.isLoading)
        
        let expect = expectation(description: "state changes by UserListAction.firstFetchStart")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isLoading else { return }
            
            XCTAssertTrue(state.isLoading)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserListAction.firstFetchStart
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertTrue(store.state.isLoading)
    }
    
    /// ローディングの終了の状態を確認する
    func testFirstFetchEnd() {
        // ローディング開始状態に設定
        dependency.dispatcher.dispatch(
            UserListAction.firstFetchStart
        )
        
        // 開始状態（isLoading == true）であることを確認
        XCTAssertTrue(store.state.isLoading)
        
        let expect = expectation(description: "state changes by UserListAction.firstFetchEnd")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isLoading == false else { return }
            
            XCTAssertFalse(state.isLoading)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserListAction.firstFetchEnd
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertFalse(store.state.isLoading)
    }
    
    /// 追加ローディングの開始の状態を確認する
    func testMoreFetchStart() {
        // 初期値であることを確認
        XCTAssertFalse(store.state.isMoreLoading)
        
        let expect = expectation(description: "state changes by UserListAction.moreFetchStart")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isMoreLoading else { return }
            
            XCTAssertTrue(state.isMoreLoading)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserListAction.moreFetchStart
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertTrue(store.state.isMoreLoading)
    }
    
    /// 追加ローディングの終了の状態を確認する
    func testMoreFetchEnd() {
        // ローディング開始状態に設定
        dependency.dispatcher.dispatch(
            UserListAction.moreFetchStart
        )
        
        // 開始状態（isLoading == true）であることを確認
        XCTAssertTrue(store.state.isMoreLoading)
        
        let expect = expectation(description: "state changes by UserListAction.moreFetchEnd")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isMoreLoading == false else { return }
            
            XCTAssertFalse(state.isMoreLoading)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserListAction.moreFetchEnd
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertFalse(store.state.isMoreLoading)
    }
    
    func testApiError() {
        // 初期値であることを確認
        XCTAssertNil(store.state.apiError)
        
        // 期待する結果
        let result = URLError(.badURL)
        
        let expect = expectation(description: "state changes by UserListAction.apiError")
        
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard let apiError = state.apiError else { return }
            XCTAssertEqual(apiError.localizedDescription, result.localizedDescription)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserListAction.apiError(
                error: result
            )
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertEqual(store.state.apiError?.localizedDescription, result.localizedDescription)
    }
}
