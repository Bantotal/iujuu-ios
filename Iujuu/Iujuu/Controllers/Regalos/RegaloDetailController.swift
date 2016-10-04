//
//  RegaloDetailController.swift
//  Iujuu
//
//  Created by Diego Ernst on 10/5/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

class RegaloDetailController: XLViewController {

    var regalo: Regalo!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        addLeftNavigationCancel(withTarget: self, action: #selector(RegaloDetailController.cancel))
    }

    func cancel() {
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            navigationController?.popViewController(animated: true)
        } else if let confirmCodeViewController = R.storyboard.invitedFlow.confirmationCodeViewController() {
            confirmCodeViewController.regalo = regalo
            UIApplication.changeRootViewController(confirmCodeViewController)
        }
    }

}
