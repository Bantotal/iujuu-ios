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
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(request)
        webView.delegate = self
        cancelButton.setStyle(.primary)
        cancelButton.layer.cornerRadius = 0
        cancelButton.setTitle(UserMessages.cancel, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
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
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        LoadingIndicator.hide()
        let presenter = presentingViewController
        dismiss(animated: true, completion: {
            presenter?.showError(UserMessages.Home.galiciaError)
        })
    }

    func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}
