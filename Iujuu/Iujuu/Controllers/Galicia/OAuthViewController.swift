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

class OAuthViewController: XLViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var request: URLRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(request)
        webView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.show()
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

    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingIndicator.hide()
        debugPrint(webView.request?.url)
//        if let url = webView.request?.url, url.absoluteString.hasPrefix(Constants.Oauth.loginUrl) {
//
//        }
    }

}
