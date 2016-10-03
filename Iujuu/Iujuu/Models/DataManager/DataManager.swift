//
//  DataManagerProtocol.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol DataManagerProtocol {

    var user: User? { get }

    func getRegalos() -> Observable<Results<Regalo>>
    func registerUser(user: User, password: String) -> Observable<User>?
    func login(username: String?, email: String?, password: String) -> Observable<Any>?
    func logout() -> Observable<Any>?
}

class DataManager {

    static var shared: DataManagerProtocol!

}
