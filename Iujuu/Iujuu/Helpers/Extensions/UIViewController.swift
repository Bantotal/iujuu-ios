//
//  UIViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func addLeftNavigationCancel(withTarget target: AnyObject?, action: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: UserMessages.cancel,
            style: .plain,
            target: target,
            action: action)
    }

}
