//
//  RegaloCell.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/29/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import XLSwiftKit
import SwiftDate

class RegaloCell: UITableViewCell {

    @IBOutlet weak var motivoImageView: UIImageView!
    @IBOutlet weak var motivoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dateLabelBackground: UIView!
    @IBOutlet weak var dateLabel: UILabel!

    static let rowHeight = suggestedHorizontalConstraint(242)

    override func awakeFromNib() {
        super.awakeFromNib()

        borderView.layer.borderColor = UIColor.ijSeparatorGrayColor().cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        borderView.layer.shadowColor = UIColor.black.cgColor
        borderView.layer.shadowRadius = 2
        borderView.layer.shadowOpacity = 0.23

        motivoLabel.textColor = .ijSoftBlackColor()
        nameLabel.textColor = .ijSoftBlackColor()
        statusLabel.textColor = .ijGreyishBrownColor()

        motivoLabel.font = .regular(size: 16)
        statusLabel.font = .semibold(size: 16)
        nameLabel.font = .bold(size: 27)

        dateLabel.textColor = .ijWhiteColor()
        dateLabel.font = .bold(size: 14)

    }

    func setup(regalo: Regalo) {
        let motivo = regalo.getMotivo()
        motivoLabel.text = NSLocalizedString("{0} de", comment: "").parametrize(motivo?.rawValue ?? regalo.motivo)
        nameLabel.text = regalo.descripcion
        statusLabel.text = regalo.paid ? UserMessages.Home.didParticipate : UserMessages.Home.notParticipated
        motivoImageView.image = motivo?.image()
        if 7.days.fromNow > regalo.fechaDeCierre && Date() < regalo.fechaDeCierre {
            dateLabelBackground.isHidden = false
            let days = regalo.fechaDeCierre.daysFrom(date: Date())
            if days == 0 {
                dateLabel.text = NSLocalizedString("Quedan {0} horas!", comment: "").parametrize(regalo.fechaDeCierre.hoursFrom(date: Date()))
            } else {
                dateLabel.text = NSLocalizedString("Quedan {0} dias!", comment: "").parametrize(days)
            }
        } else {
            dateLabelBackground.isHidden = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabelBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

}
