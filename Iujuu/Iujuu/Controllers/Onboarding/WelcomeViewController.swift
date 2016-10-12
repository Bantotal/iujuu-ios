//
//  WelcomeViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Opera
import XLSwiftKit

class WelcomeViewController: XLViewController {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToButtonsConstraint: NSLayoutConstraint!

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

        buttonHeightConstraint.constant = suggestedVerticalConstraint(70)
        bottomToButtonsConstraint.constant = suggestedVerticalConstraint(30)
    }

}
