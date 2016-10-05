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
    var userId: Int? {
        didSet {
            if let id = userId, RealmManager.shared.defaultRealm.object(ofType: User.self, forPrimaryKey: id as AnyObject) == nil {
                let user = User(id: id, nombre: "", apellido: "", email: "")
                GCDHelper.runOnMainThread {
                    try? user.save()
                }
            }
        }
    }

    private init() { }

    func getRegalos() -> Observable<Results<Regalo>> {
        let regalos = RealmManager.shared.defaultRealm.objects(Regalo.self)
        let dbObservable = Observable.from(RealmManager.shared.defaultRealm.objects(Regalo.self))
        if let userId = userId {
            Router.Regalo.List(userId: userId).rx_collection("regalos").do(onNext: { [weak self] (collection: [Regalo]) in
                self?.updateRegalos(collection)
                }).subscribe().addDisposableTo(disposeBag)
        }

        return Observable.of(Observable.just(regalos), dbObservable).switchLatest()
    }

    func getAccounts() -> Observable<[Account]> {
        return Router.Galicia.Accounts().rx_collection()
    }

    func registerUser(user: User, password: String) -> Observable<User>? {
        return Router.Session.Register(nombre: user.nombre, apellido: user.apellido, documento: user.documento, username: user.username, email: user.email, password: password).rx_anyObject().do(onNext: { _ in
            //TODO: Instead of this we should call login
                GCDHelper.runOnMainThread {
                    try? user.save()
                }
                AppDelegate.logUser(user: user)
        }).map { _ in user }
    }

    func login(username: String?, email: String?, password: String) -> Observable<Any>? {
        return Router.Session.Login(username: username, email: email, password: password).rx_anyObject().do(onNext: { [weak self] object in
            let json = JSON(object)
            guard let userId = json["userId"].int else { return }
            if let token = json["id"].string {
                SessionController.sharedInstance.token = token
            }
            self?.userId = userId
            SessionController.saveCurrentUserId()
            //TODO: get user from server and then:
//            AppDelegate.logUser(user: self?.getUser())
        })
    }

    func logout() -> Observable<Any>? {
        let userToken = SessionController.sharedInstance.token

        guard let _ = userToken else { return Observable.empty() }

        return Router.Session.Logout().rx_anyObject().do(onNext: { object in
            SessionController.sharedInstance.logOut()
        })
    }

    private func updateRegalos(_ regalos: [Regalo]) {
        GCDHelper.runOnMainThread {
            try? Regalo.save(regalos, update: true, removeOld: true)
        }
    }


    func getUser() -> User? {
        if let userId = userId {
            return RealmManager.shared.defaultRealm.object(ofType: User.self, forPrimaryKey: userId as AnyObject)
        } else {
            return nil
        }

    }
}
