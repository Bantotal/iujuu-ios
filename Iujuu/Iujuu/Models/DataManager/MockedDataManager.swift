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
import Opera
import SwiftyJSON
import Decodable

class MockedDataManager: DataManagerProtocol {

    static let shared = MockedDataManager()

    private init() { }

    var userId: Int?

    //MARK: - Mocked functions

    func getRegalos() -> Observable<[Regalo]> {
        guard userId != 1 else {
            return Observable.just([])
        }
        
        let json = getJsonFromPath(path: "RegalosJson")
        let regalosJson = json?["regalos"]
        do {
            let regalosList = try [Regalo].decode(regalosJson)
            return Observable.just(regalosList)
        } catch {
            print(error)
            return Observable.just([])
        }
    }

    func reloadRegalos() {}

    func getAccounts() -> Observable<[Account]> {
        return Observable.empty()
    }

    func chooseAccount(cuentaId: String, amount: Int, date: Date, text: String) -> Observable<Any> {
        return Observable.empty()
    }

    func getRegalo(withCode code: String, onlyFromBackend: Bool = false) -> Observable<Regalo> {
        guard code == "AAAAA" else {
            return Observable.error(NSError.ijError(code: .regaloNotFoundForCode))
        }
        
        let json = getJsonFromPath(path: "RegaloJson")
        do {
            let regalo = try Regalo.decode(json)
            return Observable.just(regalo)
        } catch {
            print(error)
            return Observable.empty()
        }
    }
    
    func joinToRegalo(regalo: Regalo) -> Observable<Void> {
        return Observable.empty()
    }

    func registerUser(user: User, password: String) -> Observable<User> {
        if user.nombre == "ErrorUser" {
            return Observable.error(NSError.ijError(code: .loginParseResponseError))
        } else {
            return Observable.just(user)
        }
    }

    func login(username: String?, email: String?, password: String) -> Observable<User> {
        if email == "error@error.com" {
            return Observable.error(NSError.ijError(code: .loginParseResponseError))
        } else {
            if email == "empty@empty.com" {
                userId = 1
            } else {
                userId = 2
            }
            return Observable.just(User(id: 1, nombre: "", apellido: "", email: ""))
        }
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
        return Observable.just([])
    }

    func pagarRegalo(regaloId: Int, importe: String, imagen: String? = nil, comentario: String? = nil) -> Observable<Any> {
        return Observable.empty()
    }

    func closeRegalo(regaloId: Int, email: String) -> Observable<Any> {
        return Observable.empty()
    }

    //MARK: - Json parsing functions

    private func getJsonFromPath(path: String) -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: path, ofType: "json") else {
            return [:]
        }

        do {
            let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
            do {
                return try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            } catch {
                return [:]
            }
        } catch {
            return [:]
        }
    }
}
