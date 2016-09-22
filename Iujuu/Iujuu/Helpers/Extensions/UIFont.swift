//
//  UIFont.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit

extension UIFont {

    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: UIDevice.current.fontSizeForDevice(size))!
    }

    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans", size: UIDevice.current.fontSizeForDevice(size))!
    }

    static func light(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: UIDevice.current.fontSizeForDevice(size))!
    }
    
}
