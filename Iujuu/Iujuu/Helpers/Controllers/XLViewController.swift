//
//  XLViewController.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class XLViewController: UIViewController {
    let disposeBag = DisposeBag()

}

class XLWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var request: URLRequest!
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(request)
        cancelButton.setStyle(.primary)
        cancelButton.layer.cornerRadius = 0
        cancelButton.setTitle(UserMessages.cancel, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.show()
    }

    func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingIndicator.hide()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        LoadingIndicator.hide()
    }
}
