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

class RealDataManager: DataManagerProtocol {

    static let shared = RealDataManager()

    var user: User? {
        return RealmManager.shared.defaultRealm.objects(User.self).first
    }

    private init() { }

    func getRegalos() -> Observable<Results<Regalo>> {
        let regalos = RealmManager.shared.defaultRealm.objects(Regalo.self)
        let dbObservable = Observable.from(RealmManager.shared.defaultRealm.objects(Regalo.self))
        let _ = Observable<Results<Regalo>>.empty() // TODO: consume api and write db
        return Observable.of(Observable.just(regalos), dbObservable).merge()
    }

    func getUser() -> Observable<User>? {
        guard let user = RealmManager.shared.defaultRealm.objects(User.self).first else { return nil }
        let dbObservable = Observable.from(RealmManager.shared.defaultRealm.objects(User.self)).map { $0.first! }
        let _ = Observable<User>.empty() // TODO: consume api and write db
        return Observable.of(Observable.just(user), dbObservable).merge()
    }

    func registerUser(user: User, password: String) -> Observable<User>? {
        return Router.Session.Register(nombre: user.nombre, apellido: user.apellido, documento: user.documento, username: user.username, email: user.email, password: password).rx_anyObject().do(onNext: { object in
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
