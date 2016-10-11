//
//  ShareRegaloController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/26/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import XLSwiftKit

class ShareRegaloViewController: XLViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareLabel: UITextField!
    @IBOutlet weak var shareImage: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var shareLabelHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeToHelpConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorToCodeConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleToHelpConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpToShareViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareViewToButtonConstraint: NSLayoutConstraint!
    var code: String!

    var shareUrlString: String {
        return Constants.Texts.shareBaseUrl.parametrize(code)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        separatorLine.backgroundColor = .ijSeparatorGrayColor()
        setupLabels()
        setupShareView()
        setupButtons()
        setupTexts()
        setupConstraints()
    }

    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .ijOrangeColor()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

    func setupConstraints() {
        topConstraint.constant = suggestedVerticalConstraint(34)
        titleToHelpConstraint.constant = suggestedVerticalConstraint(34)
        helpToShareViewConstraint.constant = suggestedVerticalConstraint(24)
        shareViewToButtonConstraint.constant = suggestedVerticalConstraint(40)
        buttonHeightConstraint.constant = suggestedVerticalConstraint(60)
        separatorToCodeConstraint.constant = suggestedVerticalConstraint(40)
        codeToHelpConstraint.constant = suggestedVerticalConstraint(24)
        bottomConstraint.constant = suggestedVerticalConstraint(34)
    }

    func setupLabels() {
        for label in [titleLabel, codeLabel] {
            label?.font = .semibold(size: 36)
            label?.textColor = .ijSoftBlackColor()
        }

        for label in [textLabel1, textLabel2] {
            label?.font = .regular(size: 17)
            label?.textColor = .ijTextBlackColor()
        }
    }

    func setupShareView() {

        shareLabel.font = .regular(size: 17)
        shareLabel.minimumFontSize = 10
        shareLabel.textColor = .ijTextBlackColor()
        shareLabel.isEnabled = false
        shareView.layer.borderWidth = 1
        shareView.layer.borderColor = UIColor.ijPlaceHolderGrayColor().cgColor
        shareImage.setImage(R.image.clipboard()?.withRenderingMode(.alwaysOriginal), for: .normal)
        shareImage.addTarget(self, action: #selector(copyUrl), for: .touchUpInside)
    }

    func setupTexts() {
        textLabel1.text = UserMessages.Share.helpText1
        textLabel2.text = UserMessages.Share.helpText2
        codeLabel.text = code
        shareButton.setTitle(UserMessages.share, for: .normal)
        shareLabel.text = shareUrlString
        titleLabel.text = UserMessages.Share.title
        navigationItem.rightBarButtonItem?.title = UserMessages.finish
    }

    func setupButtons() {
        shareButton.setStyle(.primary)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem?.action = #selector(finishTapped)
        navigationItem.rightBarButtonItem?.target = self
    }

    func copyUrl() {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = shareUrlString
    }

    func finishTapped() {
        dismiss(animated: true, completion: nil)
    }

    func shareTapped() {
        let shareController = UIActivityViewController(activityItems: [shareUrlString], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }

}

extension UserMessages.Share {

    static let helpText1 = NSLocalizedString("Comparte este código con los demás integrantes para invitarlos a participar.", comment: "")
    static let helpText2 = NSLocalizedString("También puedes compartir este código para agregar el regalo manualmente desde la app.", comment: "")
    static let title = NSLocalizedString("Regalo creado!", comment: "")

}
