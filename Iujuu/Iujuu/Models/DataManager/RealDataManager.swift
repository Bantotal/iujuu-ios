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
        return Router.Session.Register(nombre: user.nombre, apellido: user.apellido, documento: user.documento, username: user.username, email: user.email, password: password).rx_object()
    }

}
