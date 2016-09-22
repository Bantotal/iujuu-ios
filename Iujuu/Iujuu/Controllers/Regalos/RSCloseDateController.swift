//
//  RSCloseDateController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SwiftDate

class RSCloseDateViewController: BaseRegaloSetupController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = .date
        if let date = regalo.closingDate {
            datePicker.date = date
        }

        datePicker.setValue(textColor, forKey: "textColor")

        datePicker.rx.date.asObservable().do(onNext: { [weak self] date in
            self?.regalo.closingDate = date
        }).subscribe().addDisposableTo(disposeBag)

        titleLabel.text = NSLocalizedString("Fecha de cierre de la colecta", comment: "")
        titleLabel.textColor = textColor
        titleLabel.font = UIFont.regular(size: 24)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 3)
        datePicker.minimumDate = Date()
    }

}
