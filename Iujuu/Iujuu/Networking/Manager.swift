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
import SwiftyJSON

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
        return Observable.create { subscriber in
            let req = self.response(requestConvertible) { result in
                switch result.result {
                case .failure(let error):
                    subscriber.onError(error)
                case .success:
                    if let data = result.result.value?.data {
                        let json = JSON(data: data)
                        if let token = json["id"].string {
                            SessionController.sharedInstance.token = token
                            print("got token: \(token)")
                        }
                    }

                    subscriber.onNext(result)
                    subscriber.onCompleted()
                }
            }
            return Disposables.create {
                req.cancel()
            }
        }
    }

}

struct Router {

    static let baseUsuariosString = "usuarios"

    struct Session {}
    struct Regalo {}

}

struct Logger: Opera.ObserverType {

    func willSendRequest(_ alamoRequest: Alamofire.Request, requestConvertible: URLRequestConvertible) {
        debugPrint(alamoRequest)
    }

}
