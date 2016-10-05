//
//  HTTPURLResponse.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/5/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation

extension URLRequest {
    func isGaliciaRequest() -> Bool {
        return url?.absoluteString.hasPrefix(Constants.Network.Galicia.baseUrl.absoluteString) == true
    }

    func isBackendRequest() -> Bool {
        return url?.absoluteString.hasPrefix(Constants.Network.baseUrl.absoluteString) == true
    }
}
