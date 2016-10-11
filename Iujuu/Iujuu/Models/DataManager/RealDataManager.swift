//
//  RealDataManager.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

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
    var userId: Int?

    private init() { }

    func getRegalos() -> Observable<Results<Regalo>> {
        let regalos = RealmManager.shared.defaultRealm.objects(Regalo.self)
        let dbObservable = Observable.from(RealmManager.shared.defaultRealm.objects(Regalo.self))
        if let userId = userId {
            Router.Regalo.List(userId: userId).rx_collection("regalos").do(onNext: { [weak self] (collection: [Regalo]) in
                self?.updateRegalos(collection)
            }, onError: { error in print(error) }).subscribe().addDisposableTo(disposeBag)
        }
        return Observable.of(Observable.just(regalos), dbObservable).merge()
    }

    func getAccounts() -> Observable<[Account]> {
        return Router.Galicia.Accounts().rx_collection()
    }

    func getRegalo(withCode code: String, onlyFromBackend: Bool = false) -> Observable<Regalo> {
        let regalo = RealmManager.shared.defaultRealm.objects(Regalo.self).filter { $0.codigo == code }.first
        let regaloAPI: Observable<Regalo> = Router.Regalo.Get(code: code).rx_object("regalo")

        if let regalo = regalo, !onlyFromBackend {
            return Observable.of(Observable.just(regalo), regaloAPI).merge()
        }

        return regaloAPI
    }

    func joinToRegalo(regalo: Regalo) -> Observable<Void> {
        guard let user = getCurrentUser() else {
            return Observable.error(NSError.ijError(code: .userNotLogged))
        }
        guard let code = regalo.codigo else {
            return Observable.error(NSError.ijError(code: .unexpectedNil))
        }
        return
            Router.Regalo.Join(userId: user.id, regaloCode: code)
                .rx_anyObject()
                .flatMap { _ -> Observable<Void> in
                    regalo.paid = false
                    try? regalo.save(true)
                    return Observable.just(())
                }
    }

    func registerUser(user: User, password: String) -> Observable<User> {
        return
            Router.Session.Register(
                nombre: user.nombre,
                apellido: user.apellido,
                documento: user.documento,
                username: user.username,
                email: user.email,
                password: password
            )
            .rx_anyObject()
            .flatMap { _ in DataManager.shared.login(username: user.username, email: user.email, password: password) }
    }

    func login(username: String?, email: String?, password: String) -> Observable<User> {
        return
            Router.Session.Login(username: username, email: email, password: password)
                .rx_anyObject()
                .observeOn(MainScheduler.instance)
                .flatMap { [weak self] object -> Observable<User> in
                    let json = JSON(object)
                    guard let userId = json["userId"].int else {
                        return Observable.error(NSError.ijError(code: .loginParseResponseError))
                    }
                    if let token = json["id"].string {
                        SessionController.sharedInstance.token = token
                    }
                    self?.userId = userId
                    SessionController.saveCurrentUserId()
                    return Router.User.Get(userId: userId).rx_object()
                }
                .flatMap { (user: User) -> Observable<User> in
                    try? user.save()
                    AppDelegate.logUser(user: user)
                    return Observable.just(user)
                }
                .flatMap { (user: User) -> Observable<User> in
                    return AfterLoginPending.shared
                        .execute()
                        .catchError { error in
                            Crashlytics.sharedInstance().recordError(error)
                            return Observable.just(())
                        }
                        .map { _ in user }
                }
    }

    func logout() -> Observable<Any> {
        let userToken = SessionController.sharedInstance.token

        guard let _ = userToken else { return Observable.empty() }

        SessionController.sharedInstance.logOut()
        return Router.Session.Logout().rx_anyObject()
    }

    private func updateRegalos(_ regalos: [Regalo]) {
        GCDHelper.runOnMainThread {
            try? Regalo.save(regalos, update: true, removeOld: true)
        }
    }


    func getUser(id: Int? = nil) -> Observable<User> {
        if let id = id ?? userId {
            let user = RealmManager.shared.defaultRealm.object(ofType: User.self, forPrimaryKey: id)
            let userAPI = Router.User.Get(userId: id).rx_object().observeOn(MainScheduler.instance).do(
                onNext: { (user: User) in
                    try? user.save()
                }
            )

            if let user = user {
                return Observable.of(Observable.just(user), userAPI).merge()
            }

            return userAPI
        }

        return Observable.empty()
    }

    func getCurrentUser() -> User? {
        if let userId = userId {
            return RealmManager.shared.defaultRealm.object(ofType: User.self, forPrimaryKey: userId as AnyObject)
        } else {
            return nil
        }
    }

    func createRegalo(userId: Int, motivo: String, descripcion: String, closeDate: Date,
                      targetAmount: Int, perPersonAmount: Int, regalosSugeridos: [String], account: String) -> Observable<Regalo> {
        return Router.Regalo.Create(userId: userId, motivo: motivo, descripcion: descripcion, closeDate: closeDate,
                             targetAmount: targetAmount, perPersonAmount: perPersonAmount, regalosSugeridos: regalosSugeridos, accountId: account)
            .rx_object("regalo")
            .do(onNext: { (regalo: Regalo) in
                GCDHelper.runOnMainThread {
                    try? regalo.save()
                }
        })
    }

    func editRegalo(userId: Int, regaloId: Int, descripcion: String, closeDate: Date,
                    targetAmount: Int, perPersonAmount: Int, regalosSugeridos: [RegaloSugerido]) -> Observable<Bool> {
        return Router.Regalo.Edit(userId: userId, regaloId: regaloId, descripcion: descripcion, closeDate: closeDate,
                                    targetAmount: targetAmount, perPersonAmount: perPersonAmount, regalosSugeridos: regalosSugeridos)
            .rx_anyObject()
            .map({ (data) -> Bool in
                let json = JSON(data)
                if let updated = json["Updated"].bool {
                    return updated
                }
                return false
            })
            .do(onNext: { updated in
                if updated {
                    GCDHelper.runOnMainThread {
                        let realm = RealmManager.shared.defaultRealm
                        let regalo = realm?.object(ofType: Regalo.self, forPrimaryKey: regaloId)
                        try? realm?.write() {
                            regalo?.descripcion = descripcion
                            regalo?.fechaDeCierre = closeDate
                            regalo?.amount = targetAmount
                            regalo?.perPerson = perPersonAmount
                            regalo?.regalosSugeridos.removeAll()
                            _ = regalosSugeridos.map({ regalo?.regalosSugeridos.append($0) })
                        }
                    }
                }
            })
    }

    func chooseAccount(cuentaId: String, amount: Int, date: Date, text: String) -> Observable<Any> {
        return Router.Galicia.ChooseAccount(cuentaId: cuentaId, descripcion: text, date: Date(), amount: amount).rx_anyObject()
    }

    func getPagosUrl(account: String, amount: Int, callbackUrl: String, currency: String, motive: String, owner: String) -> Observable<(String, String)?> {
        return Router.Galicia.GetPagosUrl(account: account, amount: amount, callbackUrl: callbackUrl,
                                          currency: currency, motive: motive, owner: owner)
            .rx_anyObject().map({ (anyObject) -> (String, String)? in
                let json = JSON(anyObject)
                if let url = json["url"].string, let id = json["id"].string {
                    return (url, id)
                } else {
                    return nil
                }
        })
    }

    func voteRegalo(regaloId: Int, voto: String) -> Observable<[RegaloSugerido]> {
        guard let id = userId else {
            return Observable.error(NSError.ijError(code: .userIdNotFound))
        }

        return Router.Regalo.VotarRegalo(userId: id, regaloId: regaloId, voto: voto).rx_collection("regalosSugeridos")
    }

    func pagarRegalo(regaloId: Int, importe: String, imagen: String? = nil, comentario: String? = nil) -> Observable<Any> {
        guard let id = userId else {
            return Observable.error(NSError.ijError(code: .userIdNotFound))
        }
        return
            Router.Regalo.PagarRegalo(userId: id, regaloId: regaloId, importe: importe, comentario: comentario, imagen: imagen)
                .rx_anyObject()
                .flatMap { (object: Any) -> Observable<Any> in
                    let realm = try? RealmManager.shared.createRealm()
                    try? realm?.write {
                        let regalo = realm?.object(ofType: Regalo.self, forPrimaryKey: regaloId)
                        regalo?.paid = true
                    }
                    return Observable.just(object)
                }
    }

    func closeRegalo(regaloId: Int, email: String) -> Observable<Any> {
        guard let id = userId else {
            return Observable.error(NSError.ijError(code: .userIdNotFound))
        }

        return Router.Regalo.CloseRegalo(userId: id, regaloId: regaloId, email: email).rx_anyObject()
    }

}
