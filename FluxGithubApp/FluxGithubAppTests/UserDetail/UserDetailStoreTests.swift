//
//  UserDetailStoreTests.swift
//  FluxGithubAppTests
//
//  Created by takashico on 2022/07/30.
//

@testable import FluxGithubApp
import RxSwift
import XCTest

final class UserDetailStoreTests: XCTestCase {
    private struct Dependency {
        let store: UserDetailStore
        let dispatcher: Dispatcher
        
        init() {
            dispatcher = .shared
            store = UserDetailStoreImpl(dispatcher)
        }
    }
    
    private var dependency: Dependency!
    private var store: UserDetailStore {
        dependency.store
    }
    
    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }
    
    func testUserDetailFetched() {
        // 初期値であることを確認
        XCTAssertNil(store.state.user)
        // 期待する結果
        let result: UserDetail = UserDetail.mock()
        
        let expect = expectation(description: "state change by UserDetailAction.userDetailFetched")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard let user = state.user else { return }
            // 更新されたstateが期待通りであることを確認
            XCTAssertNotNil(state.user)
            XCTAssertEqual(user.id, result.id)
            expect.fulfill()
        })
        
        dependency.dispatcher.dispatch(
            UserDetailAction.userDetailFetched(
                user: result
            )
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertNotNil(store.state.user)
        XCTAssertEqual(store.state.user?.id, result.id)
    }
    
    func testReposListFirstFetched() {
        // 初期値であることを確認
        XCTAssertTrue(store.state.reposList.isEmpty)
        // 期待する結果
        let results: [Repos] = [Repos.mock1()]
        
        let expect = expectation(description: "state change by UserDetailAction.reposListFirstFetched")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.reposList.isEmpty == false else { return }
            // 更新されたstateが期待通りであることを確認
            XCTAssertEqual(state.reposList.count, results.count)
            XCTAssertEqual(state.reposList.first?.id, results.first?.id)
            expect.fulfill()
        })
        
        // isFork == trueのReposも含めた配列でテストを行う
        // stateにはisFork == falseのReposのみ反映される
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListFirstFetched(
                reposList: [Repos.mock1(), Repos.forkMock()],
                isDataEnded: true
            )
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        XCTAssertEqual(store.state.reposList.count, results.count)
        XCTAssertEqual(store.state.reposList.first?.id, results.first?.id)
    }
    
    func testListMoreFetched() {
        // 初回取得データを反映
        let firstFetchedList: [Repos] = [Repos.mock1()]
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListFirstFetched(
                reposList: firstFetchedList,
                isDataEnded: false
            )
        )
        // 初回取得データがあることを確認
        XCTAssertEqual(store.state.reposList.count, firstFetchedList.count)
        XCTAssertEqual(store.state.reposList.first?.id, firstFetchedList.first?.id)
        
        // 期待する結果
        let results: [Repos] = [Repos.mock1(), Repos.mock2()]
        let reposPage = 2
        
        let expect = expectation(description: "state change by UserDetailAction.reposListMoreFetched")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.reposList.count > results.count - 1 else { return }
            // 更新されたstateが期待通りであることを確認
            XCTAssertEqual(state.reposList.count, results.count)
            XCTAssertEqual(state.reposList.last?.id, results.last?.id)
            XCTAssertEqual(state.reposPage, reposPage)
            expect.fulfill()
        })
        
        // isFork == trueのReposも含めた配列でテストを行う
        // stateにはisFork == falseのReposのみ反映される
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListMoreFetched(
                page: reposPage,
                reposList: [Repos.forkMock(), Repos.mock2()],
                isDataEnded: true
            )
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        XCTAssertEqual(store.state.reposList.count, results.count)
        XCTAssertEqual(store.state.reposList.last?.id, results.last?.id)
        XCTAssertEqual(store.state.reposPage, reposPage)
    }
    
    func testApiError() {
        // 初期値であることを確認
        XCTAssertNil(store.state.apiError)
        // 期待する結果
        let result = URLError(.badURL)
        
        let expect = expectation(description: "state changes by UserDetailAction.apiError")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard let apiError = state.apiError else { return }
            
            XCTAssertEqual(apiError.localizedDescription, result.localizedDescription)
            expect.fulfill()
        })
        
        dependency.dispatcher.dispatch(
            UserDetailAction.apiError(
                error: result
            )
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertEqual(store.state.apiError?.localizedDescription, result.localizedDescription)
    }
    
    /// ローディングの開始の状態を確認する
    func testUserDetailFetchStart() {
        // 初期値であることを確認
        XCTAssertFalse(store.state.isLoading)
        
        let expect = expectation(description: "state changes by UserDetailAction.userDetailFetchStart")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isLoading else { return }
            
            XCTAssertTrue(state.isLoading)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserDetailAction.userDetailFetchStart
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertTrue(store.state.isLoading)
    }
    
    /// ローディングの終了の状態を確認する
    func testUserDetailFetchEnd() {
        // ローディング開始状態に設定
        dependency.dispatcher.dispatch(
            UserDetailAction.userDetailFetchStart
        )
        
        // 開始状態（isLoading == true）であることを確認
        XCTAssertTrue(store.state.isLoading)
        
        let expect = expectation(description: "state changes by UserDetailAction.userDetailFetchEnd")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isLoading == false else { return }
            
            XCTAssertFalse(state.isLoading)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserDetailAction.userDetailFetchEnd
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertFalse(store.state.isLoading)
    }
    
    /// リポジトリの初回ローディングの開始の状態を確認する
    func testReposListFirstFetchStart() {
        // 初期値であることを確認
        XCTAssertFalse(store.state.isReposListLoading)
        
        let expect = expectation(description: "state changes by UserDetailAction.reposListFirstFetchStart")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isReposListLoading else { return }
            
            XCTAssertTrue(state.isReposListLoading)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListFirstFetchStart
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertTrue(store.state.isReposListLoading)
    }
    
    /// リポジトリの初回ローディングの終了の状態を確認する
    func testReposListFirstFetchEnd() {
        // ローディング開始状態に設定
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListFirstFetchStart
        )

        // 開始状態（isLoading == true）であることを確認
        XCTAssertTrue(store.state.isReposListLoading)

        let expect = expectation(description: "state changes by UserDetailAction.reposListFirstFetchEnd")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isReposListLoading == false else { return }

            XCTAssertFalse(state.isReposListLoading)
            expect.fulfill()
        })

        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListFirstFetchEnd
        )

        wait(for: [expect], timeout: 1.0)
        disposable.dispose()

        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertFalse(store.state.isReposListLoading)
    }
    
    /// リポジトリの追加ローディングの開始の状態を確認する
    func testReposListMoreFetchStart() {
        // 初期値であることを確認
        XCTAssertFalse(store.state.isReposListLoading)
        
        let expect = expectation(description: "state changes by UserDetailAction.reposListMoreFetchStart")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isReposListLoading else { return }
            
            XCTAssertTrue(state.isReposListLoading)
            expect.fulfill()
        })
        
        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListMoreFetchStart
        )
        
        wait(for: [expect], timeout: 1.0)
        disposable.dispose()
        
        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertTrue(store.state.isReposListLoading)
    }
    
    /// リポジトリの追加ローディングの終了の状態を確認する
    func testReposListMoreFetchEnd() {
        // ローディング開始状態に設定
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListMoreFetchStart
        )

        // 開始状態（isLoading == true）であることを確認
        XCTAssertTrue(store.state.isReposListLoading)

        let expect = expectation(description: "state changes by UserDetailAction.reposListMoreFetchEnd")
        let disposable = store.stateObservable.subscribe(onNext: { state in
            guard state.isReposListLoading == false else { return }

            XCTAssertFalse(state.isReposListLoading)
            expect.fulfill()
        })

        // 対応するActionをdispacherに渡す
        dependency.dispatcher.dispatch(
            UserDetailAction.reposListMoreFetchEnd
        )

        wait(for: [expect], timeout: 1.0)
        disposable.dispose()

        // store.stateで取得できるデータも更新されていることを確認
        XCTAssertFalse(store.state.isReposListLoading)
    }
}
