//
//  HomeHeaderView.swift
//  Iujuu
//
//  Created by user on 10/12/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit

class HomeHeaderView: OwnerView {

    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var settingsTappedAction: () -> () = {}

    override func viewForContent() -> UIView? {
        return R.nib.homeHeaderView.firstView(owner: self)
    }

    override func setup() {
        super.setup()
        contentView.backgroundColor = .clear
        setSettingsButton()
        setTitle()
    }

    private func setSettingsButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeHeaderView.settingsTapped))
        settingsIcon.addGestureRecognizer(tap)
        settingsIcon.isUserInteractionEnabled = true
    }

    func settingsTapped() {
        settingsTappedAction()
    }

    private func setTitle() {
        titleLabel.font = UIFont.regular(size: 20)
        titleLabel.textColor = UIColor.ijGreyishBrownColor()
    }

}
