//
//  UserMessages.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation

struct UserMessages {
    
    struct Onboarding { }

}

extension UserMessages.Onboarding {
    
    static let texts = [
        NSLocalizedString("IUJUU te permite organizar tus colectas para regalos colectivos", comment: ""),
        NSLocalizedString("Crea una colecta e invita a tus amigos a participar", comment: ""),
        NSLocalizedString("Cada uno deja sus mensajes y aporta dinero de forma segura", comment: ""),
        NSLocalizedString("El organizador retira el dinero para el regalo o se envia un cupon al destinatario", comment: "")
    ]
    
    static let done = NSLocalizedString("Entendido", comment: "")
    
}
