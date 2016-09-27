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
    func getUser() -> Observable<User>?
    func registerUser(user: User, password: String) -> Observable<User>?
    
}

class DataManager {

    static var shared: DataManagerProtocol!

}
