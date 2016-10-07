//
//  UserEndpoints.swift
//  Iujuu
//
//  Created by Diego Ernst on 10/7/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Alamofire
import Opera
import SwiftDate
import RxSwift
import XLSwiftKit

extension Router.User {

    struct Get: GetRouteType {

        let userId: Int
        var path: String { return "\(Router.baseUsuariosString)/\(userId)" }

    }

}
