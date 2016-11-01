//
//  ConfirmacionEnvioViewController.swift
//  Iujuu
//
//  Created by user on 10/11/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit

class ConfirmacionEnvioViewController: UIViewController {

    var email: String? = nil

    //MARK: - Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!

    //MARK: - Constraints

    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonToLabelConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyles()
        setConstraints()
        setText()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = UserMessages.ConfirmarEnvio.title
        navigationItem.hidesBackButton = true
    }

    private func setUpStyles() {
        titleLabel.font = .bold(size: 36)
        infoLabel.font = .regular(size: 17)
        okButton.setStyle(.primary)
    }

    private func setConstraints() {
        imageHeight.constant = suggestedVerticalConstraint(180)
        imageWidth.constant = imageHeight.constant
        buttonToLabelConstraint.constant = suggestedVerticalConstraint(50)
    }

    private func setText() {
        guard let emailToShow = email else {
            return
        }

        infoLabel.text = UserMessages.ConfirmarEnvio.infoMessage.parametrize(emailToShow)
    }

    @IBAction func okPressed() {
        UIApplication.changeRootViewController(R.storyboard.main().instantiateInitialViewController()!)
    }
}
