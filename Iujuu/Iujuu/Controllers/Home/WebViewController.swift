//
//  WebViewController.swift
//  Iujuu
//
//  Created by user on 9/30/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var pageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        setNavigationBar()
    }

    private func setWebView() {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        webView.loadHTMLString("<br /><h2>Hello world!!!</h2>", baseURL: nil)
        self.view.addSubview(webView)
    }

    private func setNavigationBar() {
        guard let titleToShow = pageTitle else {
            return
        }

        title = titleToShow
    }

}
