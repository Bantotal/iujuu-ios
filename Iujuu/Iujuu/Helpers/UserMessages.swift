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
    struct RegalosSetup { }
    struct RegaloPreview { }
    struct Register { }
    struct Share { }
    struct Home { }

    static let cancel = NSLocalizedString("Cancelar", comment: "")
    static let email = NSLocalizedString("Correo Electrónico", comment: "")
    static let firstName = NSLocalizedString("Nombre", comment: "")
    static let lastname = NSLocalizedString("Apellido", comment: "")
    static let password = NSLocalizedString("Contraseña", comment: "")
    static let back = NSLocalizedString("Atrás", comment: "")
    static let next = NSLocalizedString("Siguiente", comment: "")
    static let share = NSLocalizedString("Compartir", comment: "")
    static let finish = NSLocalizedString("Finalizar", comment: "")
    static let networkError = NSLocalizedString("Hubo un error de conexión. Por favor inténtelo más tarde.", comment: "")
    static let errorTitle = NSLocalizedString("Error", comment: "")

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

extension UserMessages.Register {
    
    static let registerError = NSLocalizedString("Ocurrió un error al intentar registrarse. Por favor intente de nuevo!", comment: "")
    static let passwordInvalid = NSLocalizedString("Password must have 6 character, one capital letter and one number!", comment: "")
    static let loginError = NSLocalizedString("Nombre de usuario o clave incorrecta.", comment: "")
    static let duplicatedEmail = NSLocalizedString("Ya ha un usuario registrado con este email.", comment: "")
    
}

extension UserMessages.RegalosSetup {

    static let accountText = NSLocalizedString("Cuenta a asociar", comment: "")
    static let accountHelp = NSLocalizedString("El dinero de la colecta se irá acumulando en la cuenta seleccionada", comment: "")
    static let accountButtonText = NSLocalizedString("Agregar una cuenta", comment: "")
    static let accountError = NSLocalizedString("Debe seleccionar una cuenta", comment: "")
    static let motivoText = NSLocalizedString("Motivo", comment: "")
    static let nameError = NSLocalizedString("El nombre no puede ser vacío", comment: "")
    static let closeDateText = NSLocalizedString("Fecha de cierre de la colecta", comment: "")
    static let amountError = NSLocalizedString("El monto no puede ser vacío", comment: "")
    static let amountText = NSLocalizedString("Monto objetivo", comment: "")
    static let perPersonError = NSLocalizedString("El monto sugerido no puede ser vacío", comment: "")
    static let perPersonText = NSLocalizedString("Monto sugerido por persona", comment: "")
    static let perPersonHelp = NSLocalizedString("Los participantes podrán aportar cualquier cifra", comment: "")
}

extension UserMessages.Home {
    static let notParticipated = NSLocalizedString("Aún no participe", comment: "")
    static let didParticipate = NSLocalizedString("Ya Participé", comment: "")
}
