//
//  RegaloDetailHeader.swift
//  Iujuu
//
//  Created by user on 9/30/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit

class RegaloDetailHeader: UIView {

    //MARK: - Variables

    var showImage = true

    //MARK: - Outlets

    @IBOutlet weak var motivoImageView: UIImageView!
    @IBOutlet weak var motivoLabel: UILabel!
    @IBOutlet weak var recaudadoTitleLabel: UILabel!
    @IBOutlet weak var recaudadoNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabelBackground: UIView!

    //MARK: - Constraints

    @IBOutlet weak var labelBackgroundWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelToBottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        motivoLabel.textColor = .ijSoftBlackColor()
        motivoLabel.font = .bold(size: 28)

        dateLabel.textColor = .ijWhiteColor()
        dateLabel.font = .bold(size: 14)
        dateLabel.textAlignment = .center

        recaudadoTitleLabel.textColor = .ijBlackColor()
        recaudadoTitleLabel.font = .regular(size: 17)

        recaudadoNumberLabel.textColor = .ijBlackColor()
        recaudadoNumberLabel.font = .bold(size: 17)

        dateLabelBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        labelToBottomConstraint.constant = suggestedVerticalConstraint(60)
    }

    func setup(regalo: Regalo, animated: Bool = true) {
        setMotivoLabels(regalo: regalo)
        setMotivoImage(regalo: regalo)
        setDateLabel(regalo: regalo)
        setRecaudadoLabel(regalo: regalo)
        setProgressBar(regalo: regalo, animated: animated)
    }

    private func setMotivoLabels(regalo: Regalo) {
        motivoLabel.text = regalo.descripcion
    }

    private func setMotivoImage(regalo: Regalo) {
        guard showImage else {
            imageHeightConstraint.constant = 0
            dateLabel.isHidden = true
            dateLabelBackground.isHidden = true
            dateLabelBackground.backgroundColor = .clear
            return
        }

        imageHeightConstraint.constant = 0.6 * RegaloCell.rowHeight
        let motivo = regalo.getMotivo()
        motivoImageView.image = motivo?.image()
    }

    private func setDateLabel(regalo: Regalo) {
        let now = Date()
        if !regalo.active {
            dateLabelBackground.isHidden = false
            dateLabel.text = UserMessages.finished
        } else if regalo.hasExpired() {
            dateLabelBackground.isHidden = false
            dateLabel.text = UserMessages.Home.willFinishSoon
        } else if regalo.expiresSoon() {
            dateLabelBackground.isHidden = false
            dateLabel.text = regalo.timeStatusText
        } else {
            dateLabelBackground.isHidden = true
        }
        dateLabel.sizeToFit()
        labelBackgroundWidthConstraint.constant = max(100, dateLabel.frame.width + 16)
    }

    private func setRecaudadoLabel(regalo: Regalo) {
        recaudadoNumberLabel.text = "$\(Int(regalo.saldo)) / $\(regalo.amount)"
    }

    private func setProgressBar(regalo: Regalo, animated: Bool) {
        let percentagePaid = regalo.saldo / Double(regalo.amount)
        let barHeight = suggestedVerticalConstraint(30)
        let progressBar = ProgressBarView(frame: CGRect(x: frame.origin.x + 20, y: frame.height - suggestedVerticalConstraint(50), width: frame.width - 40, height: barHeight))
        progressBar.setProgress(percentageFull: percentagePaid, animated: animated)
        addSubview(progressBar)
    }

}
