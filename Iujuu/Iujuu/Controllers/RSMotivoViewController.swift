//
//  RSMotivoViewController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

class RSMotivoViewController: BaseRegaloSetupController {

    var motivos = ["Cumpleaños", "Aniversario", "Despedida", "Bienvenida"]
    var selectedIndex = 0

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        regalo = RegaloSetup()
        pickerView.delegate = self
        pickerView.dataSource = self

        titleLabel.text = NSLocalizedString("Motivo", comment: "")
        titleLabel.textColor = textColor
        titleLabel.font = UIFont.regular(size: 24)

        regalo.motivo = motivos.first
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 1)

        if let chosen = regalo.motivo, let index = motivos.index(of: chosen) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }

}

extension RSMotivoViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        label.text = motivos[row]
        label.textColor = textColor
        label.font = UIFont.regular(size: 23)
        label.textAlignment = .left
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        regalo.motivo = motivos[row]
        pickerView.reloadComponent(0)
    }

}

extension RSMotivoViewController: UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach {
            $0.isHidden = $0.frame.height < 1
        }

        return motivos.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
