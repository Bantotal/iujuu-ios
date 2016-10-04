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

    func getAccounts() -> Observable<[Account]> {
        return Observable.empty()
    }

    func getRegalo(withCode code: String, onlyFromBackend: Bool = false) -> Observable<Regalo> {
        return Observable.empty() // TODO:
    }

    func registerUser(user: User, password: String) -> Observable<User>? {
        return Observable.empty()
    }

    func login(username: String?, email: String?, password: String) -> Observable<Any>? {
        return Observable.empty()
    }

    func logout() -> Observable<Any>? {
        return Observable.empty()

    }

    func getUser() -> User? {
        return nil
    }

    func createRegalo(userId: Int, motivo: String, descripcion: String, closeDate: Date,
                      targetAmount: Int, perPersonAmount: Int, regalosSugeridos: [String], account: Account) -> Observable<Regalo> {
        return Observable.empty()
    }

    func getPagosUrl(account: String, amount: Int, callbackUrl: String, currency: String, motive: String, owner: String) -> Observable<(String, String)?> {
        return Observable.empty()
    }
}
