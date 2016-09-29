//
//  RealDataManager.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation

import Foundation
import RxSwift
import RxRealm
import RealmSwift
import XLSwiftKit
import Crashlytics
import SwiftyJSON
import Opera

class RealDataManager: DataManagerProtocol {

    static let shared = RealDataManager()

    var disposeBag = DisposeBag()
    var user: User? {
        return RealmManager.shared.defaultRealm.objects(User.self).first
    }

    private init() { }

    func getRegalos() -> Observable<Results<Regalo>> {
        let regalos = RealmManager.shared.defaultRealm.objects(Regalo.self)
        let dbObservable = Observable.from(RealmManager.shared.defaultRealm.objects(Regalo.self))
        if let userId = user?.id {
            Router.Regalo.List(userId: userId).rx_collection("regalos").do(onNext: { (collection: [Regalo]) in
                GCDHelper.runOnMainThread {
                    try? Regalo.save(collection)
                }
                }, onError: { error in
                    if let error = error as? OperaError {
                        switch error {
                        case let .networking(_, _, response, json):
                            print(response)
                            print(JSON(json as? AnyObject))
                        case let .parsing(_, _, response, json):
                            print(response)
                            print(JSON(data: (json as? Data)!))
                        }
                    }
            }).subscribe().addDisposableTo(disposeBag)
        }

        return Observable.of(Observable.just(regalos), dbObservable).merge()
    }

    func registerUser(user: User, password: String) -> Observable<User>? {
        return Router.Session.Register(nombre: user.nombre, apellido: user.apellido, documento: user.documento, username: user.username, email: user.email, password: password).rx_anyObject().do(onNext: { object in
            let json = JSON(object)
            if let token = json["id"].string {
                SessionController.sharedInstance.token = token
                print("got token: \(token)")
            }
            GCDHelper.runOnMainThread {
                try? user.save()
            }
            AppDelegate.logUser(user: user)
        }).map { _ in user }
    }

    func login(username: String?, email: String?, password: String) -> Observable<Any>? {
        return Router.Session.Login(username: username, email: email, password: password).rx_anyObject().do(onNext: { object in
            let json = JSON(object)
            guard let userId = json["userId"].int else { return }
            if let token = json["id"].string {
                SessionController.sharedInstance.token = token
                print("got token: \(token)")
            }
            let user = User(id: userId, nombre: "", apellido: "", email: email ?? "")
            GCDHelper.runOnMainThread {
                try? user.save()
            }
            AppDelegate.logUser(user: user)
        })
    }
}
