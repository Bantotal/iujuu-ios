//
//  RouteType.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import Opera
import Alamofire

//MARK: RouteType
extension RouteType {

    var baseURL: URL { return Constants.Network.baseUrl }
    var manager: ManagerType { return NetworkManager.singleton  }
    var retryCount: Int { return 0 }

}

//MARK: URLRequestParametersSetup
extension URLRequestParametersSetup {

    public func urlRequestParametersSetup(_ urlRequest: URLRequest, parameters: [String: Any]?) -> [String: Any]? {
        var params = parameters ?? [:]
        if let token = SessionController.sharedInstance.token {
            params[Constants.Network.AuthTokenName] = token
        }
        return params
    }

}

//MARK: URLRequestSetup
extension URLRequestSetup {

    func urlRequestSetup(_ urlRequest: URLRequest) {
        // setup url
    }

}

//MARK: GetRouteType
protocol GetRouteType: RouteType {}

extension GetRouteType {

    var method: HTTPMethod {
        return .get
    }

}

//MARK: PostRouteType
protocol PostRouteType: RouteType {}

extension PostRouteType {

    var method: HTTPMethod {
        return .post
    }

}

//MARK: DeleteRouteType
protocol DeleteRouteType: RouteType {}

extension DeleteRouteType {

    var method: HTTPMethod {
        return .delete
    }

}
