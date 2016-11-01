//
//  PagoConfirmadoViewController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/11/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit

class PagoConfirmadoViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    //MARK: Constraints
    @IBOutlet weak var textToButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var textToTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleToImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        textToButtonConstraint.constant = suggestedVerticalConstraint(30)
        textToTitleConstraint.constant = suggestedVerticalConstraint(34)
        titleToImageConstraint.constant = suggestedVerticalConstraint(30)
        topConstraint.constant = suggestedVerticalConstraint(30)
        bottomConstraint.constant = suggestedVerticalConstraint(20)
        imageHeightConstraint.constant = suggestedVerticalConstraint(180)

        titleLabel.text = UserMessages.PagoConfirmado.titleText
        textLabel.text = UserMessages.PagoConfirmado.descriptionText
        actionButton.setTitle(UserMessages.ok, for: .normal)

        title = UserMessages.PagoConfirmado.navigationTitle
        navigationItem.hidesBackButton = true

        setUpStyles()
    }

    private func setUpStyles() {
        titleLabel.textColor = .ijSoftBlackColor()
        textLabel.textColor = .ijTextBlackColor()
        titleLabel.font = .semibold(size: 36)
        textLabel.font = .regular(size: 17)
        textLabel.numberOfLines = 0
        actionButton.setStyle(.primary)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
    }

    @IBAction func okPressed() {
        UIApplication.changeRootViewController(R.storyboard.main().instantiateInitialViewController()!)
    }

}

extension UserMessages.PagoConfirmado {
    static let titleText = NSLocalizedString("Pago confirmado", comment: "")
    static let navigationTitle = NSLocalizedString("Confirmación de pago", comment: "")
    static let descriptionText = NSLocalizedString("Se ha confirmado tu pago exitosamente y tu mensaje ha sido registrado.\n\n El destinatario recibirá todos los mensajes y el dinero al finalizada el regalo.", comment: "")
}
