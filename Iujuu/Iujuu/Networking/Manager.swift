//
//  Manager.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import Opera
import Alamofire
import KeychainAccess
import RxSwift

class NetworkManager: RxManager {

    static let singleton = NetworkManager(manager: SessionManager.default)
    
    override init(manager: Alamofire.SessionManager) {
        super.init(manager: manager)
        observers = [Logger()]
    }


    func refreshToken() -> Observable<String?> {
        return Observable.just(nil)
    }

    override func rx_response(_ requestConvertible: URLRequestConvertible) -> Observable<OperaResult> {
        let response = super.rx_response(requestConvertible)
        return refreshToken().flatMap { _ in response }
    }

}

struct Router {

    static let baseUsuariosString = "usuarios"

    struct Session {}

}

struct Logger: Opera.ObserverType {

    func willSendRequest(_ alamoRequest: Alamofire.Request, requestConvertible: URLRequestConvertible) {
        debugPrint(alamoRequest)
    }

}
