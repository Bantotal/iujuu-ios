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

    func requestDidComplete(_ notification: Notification) {
        guard let task = notification.object as? URLSessionTask, let response = task.response as? HTTPURLResponse else {
            DEBUGLog("Request object not a task")
            return
        }
        if Constants.Network.successRange ~= response.statusCode {
            if let token = response.allHeaderFields["Set-Cookie"] as? String {
                SessionController.sharedInstance.token = token
            }
        } else if response.statusCode == Constants.Network.Unauthorized && SessionController.sharedInstance.isLoggedIn() {
            SessionController.sharedInstance.clearSession()
            // here you should implement AutoLogout: Transition to login screen and show an appropiate message
        }
    }

    func stylizeApp() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = .ijWhite90Color()
        navigationBarAppearance.tintColor = .ijGreyishBrownColor()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.ijTextBlackColor()]
        stylizeEurekaRows()
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
