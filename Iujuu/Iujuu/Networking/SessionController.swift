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
import OAuthSwift
import Ecno

class SessionController {

    static let sharedInstance = SessionController()
    fileprivate let keychain = Keychain(service: Constants.Keychain.serviceIdentifier)
    fileprivate init() { }

    // MARK: - Session variables
    var token: String? {
        get { return keychain[Constants.Keychain.sessionToken] }
        set { keychain[Constants.Keychain.sessionToken] = newValue }
    }

    var galiciaToken: String? {
        get { return keychain[Constants.Keychain.galiciaToken] }
        set { keychain[Constants.Keychain.galiciaToken] = newValue }
    }

    //MARK: OAuthSwift
    static var oauthSwift: OAuth2Swift = {
        let oauth = OAuth2Swift(
            consumerKey:    Constants.Oauth.ClientId,
            consumerSecret: Constants.Oauth.ClientSecret,
            authorizeUrl:   Constants.Oauth.authorizationUrl,
            accessTokenUrl: Constants.Oauth.accessTokenUrl,
            responseType:   Constants.Oauth.responseType
        )
        oauth.accessTokenBasicAuthentification = true
        return oauth
    }()

    func setupOAuthSwift() {
        if let token = galiciaToken {
            SessionController.oauthSwift.client.credential.oauthToken = token
        }
    }

    func getOAuthToken(urlHandler: OAuthSwiftURLHandlerType, onFinish: @escaping (OAuthSwiftError?) -> Void) {
        SessionController.authorize(urlHandler: urlHandler, success: { [unowned self] (credential, response, parameters) in
            self.galiciaToken = credential.oauthToken
            onFinish(nil)
        }) { (error) in
            onFinish(error)
        }
    }

    // MARK: - Session handling
    func logOut() {
        clearSession()
    }

    func isLoggedIn() -> Bool {
        return token != nil
    }

    static func hasGaliciaToken() -> Bool {
        return !SessionController.oauthSwift.client.credential.oauthToken.isEmpty
    }

    static func removeGaliciaToken() {
        SessionController.sharedInstance.galiciaToken = nil
        SessionController.oauthSwift.client.credential.oauthToken = ""
    }

    func invalidateIfNeeded() {
        if token != nil && DataManager.shared.userId == nil {
            clearSession()
        }
    }

    // MARK: - Auxiliary functions
    func clearSession() {
        token = nil
        SessionController.removeGaliciaToken()
        RealmManager.shared.eraseAll()
        Ecno.clearAll()
//        Analytics.reset()
//        Analytics.registerUnidentifiedUser()
        Crashlytics.sharedInstance().setUserEmail(nil)
        Crashlytics.sharedInstance().setUserIdentifier(nil)
        Crashlytics.sharedInstance().setUserName(nil)
    }

    static func saveCurrentUserId() {
        let defaults = UserDefaults.standard
        defaults.set(DataManager.shared.userId, forKey: Constants.Keychain.userIdentifier)
    }

    static func loadCurrentUserId() {
        let defaults = UserDefaults.standard
        DataManager.shared.userId = defaults.value(forKey: Constants.Keychain.userIdentifier) as? Int
    }

}

extension SessionController {

    static func authorize(urlHandler: OAuthSwiftURLHandlerType, success: @escaping OAuthSwift.TokenSuccessHandler,
                          failure: @escaping OAuthSwift.FailureHandler) {

        let state = generateStateWithLength(20) as String
        SessionController.oauthSwift.authorizeURLHandler = urlHandler
        _ = SessionController.oauthSwift
            .authorize(withCallbackURL: Constants.Oauth.callbackUrl,
                                            scope: Constants.Oauth.Scope, state: state,
                                            success: success,
                                            failure: failure
        )
    }
}
