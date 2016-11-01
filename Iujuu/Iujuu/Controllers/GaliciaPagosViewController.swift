//
//  GaliciaPagosViewController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/5/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol GaliciaPagosDelegate: class {
    func userDidCancel()
    func userDidConfirmTransaction()
}

class GaliciaPagosViewController: XLWebViewController, UIWebViewDelegate {

    weak var delegate: GaliciaPagosDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }

    //TODO: remove cancel button in last step

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.url)
        if let url = request.url, url.absoluteString.hasPrefix(Constants.Network.Galicia.callbackUrl) {
            delegate?.userDidConfirmTransaction()
            dismiss(animated: true, completion: nil)
            return false
        }
        return true
    }

    override func webViewDidFinishLoad(_ webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
    }

    override func dismissTapped() {
        delegate?.userDidCancel()
        super.dismissTapped()
    }

}
