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
        datePicker.locale = Constants.locale

        datePicker.rx.date.asObservable().do(onNext: { [weak self] date in
            self?.regalo.closingDate = date
        }).subscribe().addDisposableTo(disposeBag)

        titleLabel.text = UserMessages.RegalosSetup.closeDateText
        titleLabel.textColor = textColor
        titleLabel.font = .regular(size: 24)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 4)
        datePicker.minimumDate = Date()
    }

}
