//
//  NSObject+Extention.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import Foundation

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        String(describing: self)
    }

    var className: String {
        Self.className
    }
}

extension NSObject: ClassNameProtocol {}
