//
//  SessionController.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import KeychainAccess
import Opera
import RxSwift
import RealmSwift

class SessionController {

    static let sharedInstance = SessionController()
    fileprivate let keychain = Keychain(service: Constants.Keychain.serviceIdentifier)
    fileprivate init() { }

    // MARK: - Session variables
    var token: String? {
        get { return keychain[Constants.Keychain.sessionToken] }
        set { keychain[Constants.Keychain.sessionToken] = newValue }
    }

    // MARK: - Session handling
    func logOut() {
        clearSession()
    }

    func isLoggedIn() -> Bool {
        invalidateIfNeeded()
        return token != nil
    }

    func invalidateIfNeeded() {
        if token != nil && DataManager.shared.user == nil {
            clearSession()
        }
    }

    func refreshToken() -> Observable<String?> {
        //TODO: refresh session token if necessary
        return  Observable.just(nil)
    }

    // MARK: - Auxiliary functions
    func clearSession() {
        token = nil
        RealmManager.shared.eraseAll()
//        Analytics.reset()
//        Analytics.registerUnidentifiedUser()
        Crashlytics.sharedInstance().setUserEmail(nil)
        Crashlytics.sharedInstance().setUserIdentifier(nil)
        Crashlytics.sharedInstance().setUserName(nil)
    }

}
