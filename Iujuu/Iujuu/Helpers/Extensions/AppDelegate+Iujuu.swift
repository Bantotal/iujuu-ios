//
//  AppDelegate+Iujuu.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Fabric
import Alamofire
import Eureka
import Crashlytics
import SwiftDate
import XLSwiftKit

extension AppDelegate {

    func setupCrashlytics() {
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = Constants.Debug.crashlytics
    }

    // MARK: Alamofire notifications
    func setupNetworking() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AppDelegate.requestDidComplete(_:)),
            name: Alamofire.Notification.Name.Task.DidComplete,
            object: nil)
    }

    static func logUser(user: User) {
        Crashlytics.sharedInstance().setUserEmail(user.email)
        Crashlytics.sharedInstance().setUserIdentifier(String(user.id))
        Crashlytics.sharedInstance().setUserName(user.username)
    }

    func autologin() {
        SessionController.loadCurrentUserId()
        if let _ = SessionController.sharedInstance.token, let _ = DataManager.shared.userId {
            UIApplication.changeRootViewController(R.storyboard.main().instantiateInitialViewController()!)
        } else {
            UIApplication.changeRootViewController(R.storyboard.onboarding.onboardingViewController()!)
        }
    }

    func requestDidComplete(_ notification: Notification) {
        guard let task = notification.userInfo?[Notification.Key.Task] as? URLSessionTask, let response = task.response as? HTTPURLResponse else {
            DEBUGLog("Request object not a task")
            return
        }
        if task.originalRequest?.isBackendRequest() == true {
            if response.statusCode == Constants.Network.Unauthorized &&
                SessionController.sharedInstance.isLoggedIn() {
                SessionController.sharedInstance.clearSession()
                GCDHelper.runOnMainThread {
                    UIApplication.changeRootViewController(R.storyboard.onboarding.instantiateInitialViewController()!)
                }
            }
        } else if task.originalRequest?.isGaliciaRequest()  == true {
            if response.statusCode == Constants.Network.Unauthorized && SessionController.hasGaliciaToken() {
                SessionController.removeGaliciaToken()
            }
            print(response.allHeaderFields)
        }

    }

    func stylizeApp() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = .ijWhite90Color()
        navigationBarAppearance.tintColor = .ijGreyishBrownColor()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.ijTextBlackColor()]
        stylizeEurekaRows()
    }

    func setupDateFormatter() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = ISO8601Type.extended.rawValue
        Date.decoder = Date.decoder(using: formatter)
    }


    /**
     Set up your Eureka default row customization here
     */
    func stylizeEurekaRows() {

        BaseRow.estimatedRowHeight = 60
        let titleFont = UIFont.regular(size: 17)
        let textFont = UIFont.regular(size: 16)
        let titleColor = UIColor.ijPlaceHolderGrayColor()
        let textColor = UIColor.ijTextBlackColor()
        let defaultHeight = CGFloat(60)

        NameRow.defaultCellSetup = { cell, _ in
            cell.titleLabel?.font = titleFont
            cell.detailTextLabel?.font = textFont
            cell.height = { defaultHeight }
        }
        NameRow.defaultCellUpdate = { cell, _ in
            cell.titleLabel?.textColor = titleColor
            cell.detailTextLabel?.textColor = textColor
        }

        PasswordRow.defaultRowInitializer = {
            $0.title = UserMessages.password
        }
        PasswordRow.defaultCellSetup = { cell, _ in
            cell.titleLabel?.font = titleFont
            cell.detailTextLabel?.font = textFont
            cell.height = { defaultHeight }
        }
        PasswordRow.defaultCellUpdate = { cell, _ in
            cell.titleLabel?.textColor = titleColor
            cell.detailTextLabel?.textColor = textColor
        }

        ButtonRow.defaultCellUpdate = { cell, _ in
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
            cell.textLabel?.font = UIFont.regular(size: 16)
            cell.textLabel?.textColor = UIColor.ijBlackColor()
            cell.textLabel?.textAlignment = .left
        }
        ButtonRow.defaultCellSetup = { cell, _ in
            cell.height = { defaultHeight }
        }

        EmailRow.defaultRowInitializer = {
            $0.title = UserMessages.email
        }
        EmailRow.defaultCellSetup = { cell, _ in
            cell.titleLabel?.font = titleFont
            cell.detailTextLabel?.font = textFont
            cell.height = { defaultHeight }
        }
        EmailRow.defaultCellUpdate = { cell, _ in
            cell.titleLabel?.textColor = titleColor
            cell.detailTextLabel?.textColor = textColor
        }

        GenericPasswordRow.defaultCellSetup = { cell, _ in
            cell.textField.font = titleFont
            let offset = CGFloat(16)
            cell.dynamicHeight = (collapsed: defaultHeight, expanded: defaultHeight + offset)
        }
        GenericPasswordRow.defaultCellUpdate = { cell, _ in
            cell.textField.textColor = textColor
            cell.textField.attributedPlaceholder = NSAttributedString(string: UserMessages.password, attributes: [NSForegroundColorAttributeName: titleColor])
        }

    }

}
