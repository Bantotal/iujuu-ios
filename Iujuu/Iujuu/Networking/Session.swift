//
//  NetworkUser.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import Alamofire
import Opera
import SwiftDate
import RxSwift
import XLSwiftKit

extension Router.Session {

    struct Register: PostRouteType {

        let nombre: String
        let apellido: String
        let documento: String?
        let username: String?
        let email: String
        let password: String

        var path: String {
            return Router.baseUsuariosString
        }

        var parameters: [String : Any]? {
            return cleanedDict([
                "nombre": nombre,
                "apellido": apellido,
                "email": email,
                "password": password,
                "documento": documento,
                "username": username
            ])
        }

    }

    struct Login: PostRouteType {

        let username: String?
        let email: String?
        let password: String

        var path: String {
            return "\(Router.baseUsuariosString)/login"
        }

        var parameters: [String : Any]? {
            return cleanedDict([
                "email": email,
                "password": password,
                "username": username
                ])
        }

    }

    struct Logout: PostRouteType {

        var path: String {
            return "\(Router.baseUsuariosString)/logout"
        }

        func urlRequestSetup(_ urlRequest: inout URLRequest) {
            let url = baseURL.appendingPathComponent(path).absoluteString + "?\(Constants.Network.AuthTokenName)=\(SessionController.sharedInstance.token ?? "")"
            urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpMethod = method.rawValue

            do {
                urlRequest = try encoding.encode(urlRequest, with: parameters)
            } catch {}
        }

    }
}
