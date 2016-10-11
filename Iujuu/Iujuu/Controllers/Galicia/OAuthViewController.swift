//
//  OAuthViewController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/3/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

class OAuthViewController: XLWebViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        debugPrint(request.url)
        if let url = request.url, url.absoluteString.hasPrefix(Constants.Oauth.callbackUrl) {
            OAuthSwift.handle(url: url)
            dismiss(animated: true, completion: nil)
            return false
        }
        return true
    }

    override func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        super.webView(webView, didFailLoadWithError: error)
        let presenter = presentingViewController
        dismiss(animated: true, completion: {
            presenter?.showError(UserMessages.Home.galiciaError)
        })
    }

}
