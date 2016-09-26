//
//  WelcomeViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        facebookButton.setStyle(.primaryWith(color: .ijDenimBlueColor()))
        createAccountButton.setStyle(.secondary(borderColor: .ijDeepOrangeColor()))
        loginButton.setStyle(.borderless(titleColor: .white))
    }

}
