//
//  FinalizarColectaHeader.swift
//  Iujuu
//
//  Created by user on 10/10/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit

class FinalizarColectaHeader: OwnerView {

    //MARK: - Outlets

    @IBOutlet weak var motivoLabel: UILabel!
    @IBOutlet weak var recaudadoLabel: UILabel!
    @IBOutlet weak var recaudacionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!

    //MARK: - Constraints

    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!

    override func setup() {
        super.setup()
        setUpStyles()
        setUpDimensions()
    }

    override func viewForContent() -> UIView? {
        return R.nib.finalizarColectaHeader.firstView(owner: self)
    }

    private func setUpStyles() {
        setUpLabelStyles()
    }

    private func setUpLabelStyles() {
        motivoLabel.font = .bold(size: 28)
        recaudadoLabel.font = .regular(size: 17)
        recaudacionLabel.font = .bold(size: 20)
        infoLabel.font = .regular(size: 17)
        tipLabel.font = .regular(size: 14)
    }

    func setRegaloInfo(regaloToShow: Regalo) {
        motivoLabel.text = regaloToShow.descripcion
        recaudacionLabel.text = "$\(Int(regaloToShow.saldo)) / $\(regaloToShow.amount)"
    }

    private func setUpDimensions() {
        imageWidth.constant = suggestedVerticalConstraint(170)
        imageHeight.constant = imageWidth.constant
    }

}
