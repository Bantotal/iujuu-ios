//
//  Manager.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
//import Opera
import Alamofire
import KeychainAccess
import RxSwift

class NetworkManager: SessionManager {

    static let singleton = NetworkManager()

    override public init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        delegate: SessionDelegate = SessionDelegate(),
        serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
        super.init(configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
    }
    
//        override init() {
//        super.init()
////        observers = [Logger()]
//    }

//    override func rx_response(_ requestConvertible: URLRequestConvertible) -> Observable<OperaResult> {
//        let response = super.rx_response(requestConvertible)
//        return SessionController.sharedInstance.refreshToken().flatMap { _ in response }
//    }
}

final class Route {}

//struct Logger: Opera.ObserverType {
//    func willSendRequest(_ alamoRequest: Alamofire.Request, requestConvertible: URLRequestConvertible) {
//        debugPrint(alamoRequest)
//    }
//}
