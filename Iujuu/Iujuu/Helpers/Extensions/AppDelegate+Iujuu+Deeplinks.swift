//
//  AppDelegate+Iujuu+Deeplinks.swift
//  Iujuu
//
//  Created by Diego Ernst on 10/4/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDynamicLinks
import Crashlytics
import DeepLinkKit
import RxSwift

extension AppDelegate {

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url as URL)
        if let url = dynamicLink?.url {
            handleURL(url)
            return true
        }
        handleURL(url as URL)
        return false
    }

    @objc(application:continueUserActivity:restorationHandler:) func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        let handled = FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(userActivity.webpageURL!) { [weak self] (dynamiclink, error) in
            if let error = error {
                UIApplication.topViewController()?.showError(UserMessages.errorTitle, message: UserMessages.Deeplinks.invalidDeepLink)
                Crashlytics.sharedInstance().recordError(error)
                return
            }

            guard let url = dynamiclink?.url else {
                self?.showInvalidDeepLinkError()
                return
            }

            self?.handleURL(url)
        }
        return handled!
    }

    func setupDeepLinkRouter() {
        deepLinkRouter = DPLDeepLinkRouter()
        deepLinkRouter.register(handleDynamicLink, forRoute: Constants.Network.dynamicLinkUrl)
        deepLinkRouter.register(handleInvite, forRoute: "/invite")
    }

    // MARK: - Helpers

    private func handleURL(_ url: URL) {
        deepLinkRouter.handle(url) { _, error in
            if let error = error {
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    private func handleDynamicLink(deepLink: DPLDeepLink?) {
        guard let link = deepLink?.queryParameters["link"] as? String, let linkUrl = URL(string: link) else {
            showInvalidDeepLinkError()
            return
        }

        deepLinkRouter.handle(linkUrl) { _, error in
            if let error = error {
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

    private func handleInvite(deepLink: DPLDeepLink?) {
        guard let code = deepLink?.queryParameters["code"] as? String else {
            showInvalidDeepLinkError()
            return
        }

        LoadingIndicator.show()
        DataManager.shared.getRegalo(withCode: code, onlyFromBackend: true).timeout(10, scheduler: MainScheduler.instance).do(
            onNext: { regalo in
                LoadingIndicator.hide()
                guard let confirmCodeViewController = R.storyboard.invitedFlow().instantiateInitialViewController() as? ConfirmationCodeViewController else { return }
                confirmCodeViewController.regalo = regalo
                UIApplication.changeRootViewController(confirmCodeViewController)
            },
            onError: { error in
                LoadingIndicator.hide()
                Crashlytics.sharedInstance().recordError(error)
                UIApplication.topViewController()?.showError(
                    error,
                    alternative: (title: UserMessages.errorTitle, message: UserMessages.Deeplinks.regaloNotFound)
                )
            }
        ).subscribe().addDisposableTo(disposeBag)
    }

    private func showInvalidDeepLinkError() {
        UIApplication.topViewController()?.showError(UserMessages.errorTitle, message: UserMessages.Deeplinks.invalidDeepLink)
        Crashlytics.sharedInstance().recordError(NSError.ijError(code: .invalidDeepLink))
    }

}

extension UserMessages.Deeplinks {

    static let regaloNotFound = NSLocalizedString("No se ha podido encontrar este regalo. Intente ingresando otro código", comment: "")
    static let invalidDeepLink = NSLocalizedString("Enlace inválido", comment: "")

}
