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
    struct LogIn { }
    struct Settings { }
    struct InsertCode { }
    struct ConfirmationCode { }
    struct Deeplinks { }
    struct RegaloDetail { }
    struct ParticiparRegalo { }
    struct Participantes { }

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
    static let unkownError = NSLocalizedString("Oops! Ha ocurrido un error. Por favor inténtelo más tarde.", comment: "")
    static let noInternet = NSLocalizedString("No hay conexión a internet. Por favor inténtelo más tarde.", comment: "")
    static let errorTitle = NSLocalizedString("Error", comment: "")

}

extension UserMessages.LogIn {
    static let title = NSLocalizedString("Log in", comment: "")
    static let buttonText = NSLocalizedString("Ingresar", comment: "")
}

extension UserMessages.Settings {
    static let title = NSLocalizedString("Ajustes", comment: "")
    static let headerTitle = NSLocalizedString("Sesión iniciada", comment: "")
    static let aboutRow = NSLocalizedString("About", comment: "")
    static let faqRow = NSLocalizedString("FAQ", comment: "")
    static let legalRow = NSLocalizedString("Legal", comment: "")
    static let logoutButton = NSLocalizedString("Cerrar sesión", comment: "")
    static let logoutError = NSLocalizedString("Ocurrió un error al cerrar la sesión.", comment: "")
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
    static let balance = NSLocalizedString("Balance", comment: "")
}

extension UserMessages.Home {
    static let notParticipated = NSLocalizedString("Aún no participe", comment: "")
    static let didParticipate = NSLocalizedString("Ya Participé", comment: "")
    static let createColecta = NSLocalizedString("Nueva colecta", comment: "")
    static let actionCreateColecta = NSLocalizedString("Crear nueva colecta", comment: "")
    static let actionInsertCode = NSLocalizedString("Ingresar código de colecta", comment: "")
    static let needAccounts = NSLocalizedString("Necesita una cuenta en Banco Galicia para crear una colecta.", comment: "")
    static let galiciaAccountError = NSLocalizedString("Hubo un error tratando de obtener sus cuentas del banco Galicia. Por favor inténtelo más tarde.", comment: "")
    static let galiciaError = NSLocalizedString("Hubo un error tratando de conectarse al servicio del banco Galicia. Por favor inténtelo más tarde.", comment: "")
}

extension UserMessages.RegaloDetail {

    static let shareMessage = NSLocalizedString("Participa de este colecta!", comment: "")
    static let title = NSLocalizedString("Colecta", comment: "")
    static let participar = NSLocalizedString("Participar", comment: "")
    static let finalizar = NSLocalizedString("Finalizar colecta", comment: "")
    static let voteError = NSLocalizedString("Ocurrió un error al enviar el voto. Por favor, prueba de vuelta", comment: "")
    static let ideasTitle = NSLocalizedString("Ideas de regalo", comment: "")
    static let seeParticipants = NSLocalizedString("Ver todos", comment: "")

    static func cantidadPersonas(cantidad: Int) -> String {
        if cantidad == 1 {
            return NSLocalizedString("Ya participo 1 persona", comment: "")
        } else {
            return NSLocalizedString("Ya participaron \(cantidad) personas", comment: "")
        }
    }

}

extension UserMessages.ParticiparRegalo {

    static let title = NSLocalizedString("Participar", comment: "")
    static let messagePlaceholder = NSLocalizedString("Deja tu mensaje...", comment: "")
    static let imageMessage = NSLocalizedString("Adjuntar foto", comment: "")
    static let galiciaMessage = NSLocalizedString("Los pagos de IUJUU se realizan con la plataforma Galicia Pagos", comment: "")
    static let buttonMessage = NSLocalizedString("Pagar con galicia", comment: "")
    static let inputTitle = NSLocalizedString("Importe", comment: "")

}

extension UserMessages.Participantes {

    static let title = NSLocalizedString("Participantes", comment: "")
    static let participantesTitle = NSLocalizedString("Ya participaron en la colecta", comment: "")

}
