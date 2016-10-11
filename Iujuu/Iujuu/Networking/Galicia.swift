//
//  Galicia.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/4/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Alamofire
import Opera
import SwiftDate
import RxSwift
import XLSwiftKit

extension Router.Galicia {

    struct Accounts: GetRouteType, URLRequestSetup {

        var baseURL: URL {
            return Constants.Network.Galicia.baseUrl
        }

        var path: String {
            return "accounts/"
        }

        func urlRequestParametersSetup(_ urlRequest: URLRequest, parameters: [String : Any]?) -> [String : Any]? {
            return [:]
        }

        func urlRequestSetup(_ urlRequest: inout URLRequest) {
            let token = SessionController.oauthSwift.client.credential.oauthToken
            urlRequest.setTokenHeader(token: token)
        }

    }

    struct GetPagosUrl: PostRouteType {

        var account: String
        var amount: Int
        var callbackUrl: String
        var currency: String
        var motive: String
        var owner: String

        var baseURL: URL {
            return Constants.Network.Galicia.baseUrl
        }

        var path: String {
            return "transfers/pay-transaction/"
        }

        var parameters: [String : Any]? {
            return ["account": account,
                    "ammount": amount,
                    "callbackUrl": callbackUrl,
                    "currency": currency,
                    "motive": motive,
                    "owner": owner]
        }

        func urlRequestParametersSetup(_ urlRequest: URLRequest, parameters: [String : Any]?) -> [String : Any]? {
            return parameters
        }

        func urlRequestSetup(_ urlRequest: inout URLRequest) { }

    }

}
