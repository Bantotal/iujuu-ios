//
//  ZeplinColors.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

// Color palette

extension UIColor {

    class func ijBackgroundOrangeColor() -> UIColor {
        return UIColor(red: 232.0 / 255.0, green: 123.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    }
    
    class func ijWhiteColor() -> UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 1.0)
    }
    
    class func ijPlaceHolderGrayColor() -> UIColor {
        return UIColor(white: 155.0 / 255.0, alpha: 1.0)
    }
    
    class func ijTextBlackColor() -> UIColor {
        return UIColor(white: 33.0 / 255.0, alpha: 1.0)
    }
    
    class func ijDustyOrangeColor() -> UIColor {
        return UIColor(red: 246.0 / 255.0, green: 132.0 / 255.0, blue: 40.0 / 255.0, alpha: 1.0)
    }
    
    class func ijSeparatorGrayColor() -> UIColor {
        return UIColor(white: 213.0 / 255.0, alpha: 1.0)
    }

}

// Fonts

extension UIFont {

    static func bold(size: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans-Bold", size: size)
    }

    static func regular(size: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans", size: size)
    }

    static func light(size: CGFloat) -> UIFont? {
        return UIFont(name: "OpenSans-Light", size: size)
    }

}
