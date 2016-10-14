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

    var userId: Int? { get set }

    //MARK: - User
    func registerUser(user: User, password: String) -> Observable<User>
    func login(username: String?, email: String?, password: String) -> Observable<User>
    func logout() -> Observable<Any>
    func getCurrentUser() -> User?
    func getUser(id: Int?) -> Observable<User>

    //MARK: - Regalos
    func getRegalo(withCode code: String, onlyFromBackend: Bool) -> Observable<Regalo>
    func getRegalos() -> Observable<Results<Regalo>>
    func reloadRegalos()
    func createRegalo(userId: Int, motivo: String, descripcion: String, closeDate: Date,
                      targetAmount: Int, perPersonAmount: Int, regalosSugeridos: [String], account: String) -> Observable<Regalo>
    func voteRegalo(regaloId: Int, voto: String) -> Observable<[RegaloSugerido]>
    func pagarRegalo(regaloId: Int, importe: String, imagen: String?, comentario: String?) -> Observable<Any>
    func editRegalo(userId: Int, regaloId: Int, descripcion: String, closeDate: Date,
                      targetAmount: Int, perPersonAmount: Int, regalosSugeridos: [RegaloSugerido]) -> Observable<Void>
    func joinToRegalo(regalo: Regalo) -> Observable<Void>
    func closeRegalo(regaloId: Int, email: String) -> Observable<Any>

    //MARK: - Accounts  

    //MARK: - Galicia API
    func getPagosUrl(account: String, amount: Int, callbackUrl: String, currency: String, motive: String, owner: String) -> Observable<(String, String)?>
    func getAccounts() -> Observable<[Account]>
    func chooseAccount(cuentaId: String, amount: Int, date: Date, text: String) -> Observable<Any>
}

class DataManager {

    static var shared: DataManagerProtocol!

}
