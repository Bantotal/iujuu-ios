//
//  IdeaRegalosHeader.swift
//  Iujuu
//
//  Created by user on 10/5/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit

class IdeaRegalosHeader: UIView {

    @IBOutlet weak var titleLabel: UILabel!

    var text = "" {
        didSet {
            titleLabel.text = text
        }
    }

    override func awakeFromNib() {
        titleLabel.font = UIFont.regular(size: 17)
        titleLabel.textColor = UIColor.ijBlackColor()
    }

}
