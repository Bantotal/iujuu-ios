//
//  IURegaloNavigationController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

class IURegaloNavigationController: UINavigationController {

    var progressView: ProgressView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProgressBar()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setupProgressBar() {
        progressView = R.nib.progressView.firstView(owner: self)!
        view.addSubview(progressView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                           options: .alignAllBottom,
                                                           metrics: nil,
                                                           views: ["view": progressView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]|",
                                                           options: .alignAllLeft,
                                                           metrics: ["height": 14],
                                                           views: ["view": progressView]))
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubview(toFront: progressView)

    }

    override func popViewController(animated: Bool) -> UIViewController? {
        guard let latest = topViewController as? BaseRegaloSetupController else {
            return super.popViewController(animated: animated)
        }
        let previousVC = super.popViewController(animated: animated)
        (previousVC as? BaseRegaloSetupController)?.regalo = latest.regalo
        return previousVC
    }
}
