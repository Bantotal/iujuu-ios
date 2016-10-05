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
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: Constants.Network.Galicia.AuthHeaderName)
        }

    }

}
