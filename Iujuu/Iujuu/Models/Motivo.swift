//
//  Motivo.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

enum Motivo: String {
    
    case Cumple = "Cumpleaños"
    case Graduacion
    case Nacimiento
    case Despedida
    case Bienvenida
    case Casamiento

    func image() -> UIImage? {
        switch self {
        case .Cumple:
            return R.image.motivo_cumple()
        case .Graduacion:
            return R.image.motivo_graduacion()
        case .Nacimiento:
            return R.image.motivo_nacimiento()
        case .Casamiento:
            return R.image.motivo_casamiento()
        case .Despedida:
            return R.image.motivo_despedida()
        case .Bienvenida:
            return R.image.motivo_bienvenida()
        }
    }

    static func all() -> [Motivo] {
        return [Cumple, Graduacion, Nacimiento, Despedida, Bienvenida, Casamiento]
    }
    
}
