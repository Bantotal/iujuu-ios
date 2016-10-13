//
//  IdeaRegalosHeader.swift
//  Iujuu
//
//  Created by user on 10/5/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit

class IdeaRegalosHeader: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    var text = "" {
        didSet {
            titleLabel.text = text
        }
    }

    override func awakeFromNib() {
        titleLabel.font = UIFont.regular(size: 17)
        titleLabel.textColor = UIColor.ijBlackColor()
        leadingConstraint.constant = suggestedHorizontalConstraint(20, q6: 0.75, q5: 0.75, q4: 0.75)
    }

}
