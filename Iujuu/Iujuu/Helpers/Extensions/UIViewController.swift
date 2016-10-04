//
//  UIViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Opera

extension UIViewController {

    func addLeftNavigationCancel(withTarget target: AnyObject?, action: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: UserMessages.cancel,
            style: .plain,
            target: target,
            action: action)
    }

    func showError(_ error: Error, alternative: (title: String, message: String)) {
        if (error as NSError).domain == NSError.iujuuErrorDomain {
            showError(alternative.title, message: alternative.message)
            return
        }

        guard case let OperaError.networking(networkError, _, _, _) = error else {
            let nserror = error as NSError
            if nserror.domain == NSURLErrorDomain && (nserror.code == NSURLErrorNotConnectedToInternet || nserror.code == NSURLErrorCannotConnectToHost || nserror.code == NSURLErrorTimedOut) {
                showError(UserMessages.errorTitle, message: UserMessages.noInternet)
            } else {
                showError(alternative.title, message: alternative.message)
            }
            return
        }

        let nserror = networkError as NSError
        if nserror.domain == NSURLErrorDomain && (nserror.code == NSURLErrorNotConnectedToInternet || nserror.code == NSURLErrorCannotConnectToHost || nserror.code == NSURLErrorTimedOut) {
            showError(UserMessages.errorTitle, message: UserMessages.noInternet)
            return
        }

        showError(alternative.title, message: alternative.message)
    }


}
