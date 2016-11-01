//
//  SubtitleView.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/23/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

class SubtitleView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .regular(size: 17)
        subtitleLabel.font = .regular(size: 14)

        titleLabel.textColor = UIColor.ijTextBlackColor()
        subtitleLabel.textColor = UIColor.ijBlackColor()

        subtitleLabel.numberOfLines = 0
    }

}
