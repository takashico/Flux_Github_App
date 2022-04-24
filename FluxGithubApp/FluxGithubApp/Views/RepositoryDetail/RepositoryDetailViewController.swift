//
//  RepositoryDetailViewController.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/25.
//

import UIKit
import WebKit

class RepositoryDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var url: URL!
    
    private var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: url))
    }
}
