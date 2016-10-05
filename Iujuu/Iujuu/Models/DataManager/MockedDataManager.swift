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

    func getRegalos() -> Observable<Results<Regalo>> {
        return Observable.empty() // TODO:
    }

    func getAccounts() -> Observable<[Account]> {
        return Observable.empty() // TODO:
    }

    func registerUser(user: User, password: String) -> Observable<User>? {
        return Observable.empty() // TODO:
    }

    func login(username: String?, email: String?, password: String) -> Observable<Any>? {
        return Observable.empty() // TODO:
    }

    func logout() -> Observable<Any>? {
        return Observable.empty() // TODO:

    }

    func getUser() -> User? {
        return nil
    }
}
