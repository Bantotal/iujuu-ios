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

    @IBOutlet weak var motivoImageView: UIImageView!
    @IBOutlet weak var motivoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recaudadoTitleLabel: UILabel!
    @IBOutlet weak var recaudadoNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabelBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        motivoLabel.textColor = .ijSoftBlackColor()
        nameLabel.textColor = .ijSoftBlackColor()

        motivoLabel.font = .regular(size: 18)
        nameLabel.font = .bold(size: 28)

        dateLabel.textColor = .ijWhiteColor()
        dateLabel.font = .bold(size: 14)

        recaudadoTitleLabel.textColor = .ijBlackColor()
        recaudadoTitleLabel.font = .regular(size: 17)

        recaudadoNumberLabel.textColor = .ijBlackColor()
        recaudadoNumberLabel.font = .bold(size: 17)
    }

    func setup(regalo: Regalo) {
        let motivo = regalo.getMotivo()
        motivoLabel.text = NSLocalizedString("{0} de", comment: "").parametrize(motivo?.rawValue ?? regalo.motivo)
        nameLabel.text = regalo.descripcion
        motivoImageView.image = motivo?.image()
        setDateLabel(regalo: regalo)
        setRecaudadoLabel(regalo: regalo)
        setProgressBar(regalo: regalo)
    }

    private func setDateLabel(regalo: Regalo) {
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

    private func setRecaudadoLabel(regalo: Regalo) {
        recaudadoNumberLabel.text = "$\(Int(regalo.saldo)) / $\(regalo.amount)"
    }

    private func setProgressBar(regalo: Regalo) {
        let percentagePaid = regalo.saldo / Double(regalo.amount)
        let barHeight = suggestedVerticalConstraint(30)
        let progressBar = ProgressBarView(frame: CGRect(x: frame.origin.x + 20, y: frame.height - 50, width: frame.width - 40, height: barHeight))
        progressBar.fullColor = UIColor.ijAccentRedColor()
        progressBar.remainingColor = UIColor.ijAccentRedLightColor()
        progressBar.setProgress(percentageFull: percentagePaid)
        addSubview(progressBar)
    }

}
