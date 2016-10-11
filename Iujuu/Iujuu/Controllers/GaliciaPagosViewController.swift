//
//  GaliciaPagosViewController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/5/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

class GaliciaPagosViewController: XLWebViewController {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.url)
        if let url = request.url, url.absoluteString.hasPrefix(Constants.Oauth.callbackUrl) {
//            dismiss(animated: true, completion: nil)
            print("callback")
            return false
        }
        return true
    }

    override func webViewDidFinishLoad(_ webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        print(webView.request?.url)
    }

}
