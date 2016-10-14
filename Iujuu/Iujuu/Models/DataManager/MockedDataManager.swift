//
//  MockedDataManager.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class MockedDataManager: DataManagerProtocol {

    static let shared = MockedDataManager()

    private init() { }

    var userId: Int?

    //TODO: all functions for testing
    func getRegalos() -> Observable<Results<Regalo>> {
        return Observable.empty()
    }

    func reloadRegalos() {}

    func getAccounts() -> Observable<[Account]> {
        return Observable.empty()
    }

    func chooseAccount(cuentaId: String, amount: Int, date: Date, text: String) -> Observable<Any> {
        return Observable.empty()
    }

    func getRegalo(withCode code: String, onlyFromBackend: Bool = false) -> Observable<Regalo> {
        return Observable.empty() // TODO:
    }
    
    func joinToRegalo(regalo: Regalo) -> Observable<Void> {
        return Observable.empty()
    }

    func registerUser(user: User, password: String) -> Observable<User> {
        return Observable.empty()
    }

    func login(username: String?, email: String?, password: String) -> Observable<User> {
        return Observable.empty()
    }

    func logout() -> Observable<Any> {
        return Observable.empty()

    }

    func getCurrentUser() -> User? {
        return nil
    }

    func getUser(id: Int? = nil) -> Observable<User> {
        return Observable.empty()
    }

    func createRegalo(userId: Int, motivo: String, descripcion: String, closeDate: Date,
                      targetAmount: Int, perPersonAmount: Int, regalosSugeridos: [String], account: String) -> Observable<Regalo> {
        return Observable.empty()
    }

    func editRegalo(userId: Int, regaloId: Int, descripcion: String, closeDate: Date,
                    targetAmount: Int, perPersonAmount: Int, regalosSugeridos: [RegaloSugerido]) -> Observable<Void> {
        return Observable.empty()
    }

    func getPagosUrl(account: String, amount: Int, callbackUrl: String, currency: String, motive: String, owner: String) -> Observable<(String, String)?> {
        return Observable.empty()
    }

    func voteRegalo(regaloId: Int, voto: String) -> Observable<[RegaloSugerido]> {
        return Observable.empty() // TODO:
    }

    func pagarRegalo(regaloId: Int, importe: String, imagen: String? = nil, comentario: String? = nil) -> Observable<Any> {
        return Observable.empty() // TODO:
    }

    func closeRegalo(regaloId: Int, email: String) -> Observable<Any> {
        return Observable.empty() // TODO:
    }
}
