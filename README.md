## アプリ画面

https://user-images.githubusercontent.com/5306074/165024595-ba4cb002-7f7e-481e-b6fe-be43366c7793.mov

## アーキテクチャ構成
- Flux + MVVM + Routerを採用
    - 本アプリはUIKitで構築されているが、今後SwiftUIへ移行しやすいアーキテクチャを採用。
    - 単一方向のデータフローが実現できるため、処理の流れを追いやすく保守・改修をしやすくする。

![Flux_Github_App_Architecture](https://user-images.githubusercontent.com/5306074/182030888-2a421383-d4de-4410-b5af-0e93bd0b7987.png)

## 使用ライブラリ
※ SPMを使用しています。
- Kingfisher
- PKHUD
- RxSwift（RxCococa等も含む）
- Swinject
- SwinjectStoryboard

## 使用ツール
- Mint（パッケージ管理）
- XcodeGen
- xcconfig-extractor
- SwiftLint
- SwiftFormat

## セットアップ

    ```shell
    $ make setup
    ```
    
`make setUp`の実行により以下の内容を実行する
1. 各種ツールのインストール
2. XcodeGenによるプロジェクトファイルの生成

## 各フォルダの説明

### Common
共通で使用する内容を管理する

- Extentions

機能拡張したコードを管理する

### Request
APIリクエストに関する内容

- Core

APIリクエスト時に共通で使用する処理を管理する

### Repositories
実際に外部との通信などを行う処理を管理する

### Flux
Fluxアーキテクチャを構成する各ファイルを管理する

- Core

Action, ActionCreator, Dispatcher, State, Storeに関する共通部分を管理する

### Router
画面遷移処理を管理する

### ViewModels
ViewModelを管理する

### Models
各モデルクラスの管理

### Views
各画面を管理する

### DI
swinjectによるDI処理に関する内容
