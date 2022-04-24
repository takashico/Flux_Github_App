//
//  ViewController+Extention.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import Foundation
import UIKit

protocol StoryBoardHelper {}

extension StoryBoardHelper where Self: UIViewController {
    static func instantiate() -> Self {
        // Storyboardの命名はviewController名から”ViewController”を除いたものにしているため、不要な文字を除去する
        let storyboardName = (self.className).replacingOccurrences(of: "ViewController", with: "")
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as! Self
    }
}
