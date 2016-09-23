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
    
    static let cancel = NSLocalizedString("Cancelar", comment: "")
    static let email = NSLocalizedString("Correo Electrónico", comment: "")
    static let firstName = NSLocalizedString("Nombre", comment: "")
    static let lastname = NSLocalizedString("Apellido", comment: "")
    static let password = NSLocalizedString("Contraseña", comment: "")

}

extension UserMessages.Onboarding {
    
    static let texts = [
        NSLocalizedString("IUJUU te permite organizar tus colectas para regalos colectivos", comment: ""),
        NSLocalizedString("Crea una colecta e invita a tus amigos a participar", comment: ""),
        NSLocalizedString("Cada uno deja sus mensajes y aporta dinero de forma segura", comment: ""),
        NSLocalizedString("El organizador retira el dinero para el regalo o se envia un cupón al destinatario", comment: "")
    ]
    
    static let done = NSLocalizedString("Entendido", comment: "")
    static let register = NSLocalizedString("Registrarme", comment: "")
    
}
