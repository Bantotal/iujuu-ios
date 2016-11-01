//
//  UIView.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/26/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit

extension UIView {

    func copyView() -> UIView? {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }

}
