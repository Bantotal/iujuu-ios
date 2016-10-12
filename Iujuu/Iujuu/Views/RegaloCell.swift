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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dateLabelBackground: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var centerMotivoLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBackgroundWidthConstraint: NSLayoutConstraint!

    static let rowHeight = suggestedHorizontalConstraint(242)

    var centerMotivo = false {
        didSet {
            centerMotivoLabelConstraint.priority = centerMotivo ? 850 : 750
            motivoLabel.textAlignment = centerMotivo ? .center : .left
            statusLabel.isHidden = centerMotivo
            setNeedsLayout()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        borderView.layer.borderColor = UIColor.ijSeparatorGrayColor().cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        borderView.layer.shadowColor = UIColor.black.cgColor
        borderView.layer.shadowRadius = 2
        borderView.layer.shadowOpacity = 0.23

        motivoLabel.textColor = .ijSoftBlackColor()
        motivoLabel.numberOfLines = 0
        statusLabel.textColor = .ijGreyishBrownColor()
        statusLabel.numberOfLines = 0
        centerMotivo = false

        motivoLabel.font = .semibold(size: 22)
        statusLabel.font = .semibold(size: 16)

        dateLabel.textColor = .ijWhiteColor()
        dateLabel.font = .bold(size: 14)
        dateLabel.textAlignment = .center

    }

    func setup(regalo: Regalo) {
        let motivo = regalo.getMotivo()
        let now = Date()
        motivoLabel.text = regalo.descripcion
        motivoImageView.image = motivo?.image()
        if !regalo.active {
            statusLabel.text = regalo.paid ? UserMessages.Home.didParticipateFinished : UserMessages.Home.notParticipatedFinished
            dateLabelBackground.isHidden = false
            dateLabel.text = UserMessages.finished
        } else {
            statusLabel.text = regalo.paid ? UserMessages.Home.didParticipate : UserMessages.Home.notParticipated
            if regalo.hasExpired() {
                dateLabelBackground.isHidden = false
                dateLabel.text = UserMessages.Home.willFinishSoon
            } else if regalo.expiresSoon() {
                dateLabelBackground.isHidden = false
                dateLabel.text = regalo.timeStatusText
            } else {
                dateLabelBackground.isHidden = true
            }
        }
        dateLabel.sizeToFit()
        labelBackgroundWidthConstraint.constant = max(100, dateLabel.frame.width + 16)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabelBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

}
