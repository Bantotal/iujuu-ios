//
//  File.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import XLSwiftKit

class RegaloHeaderView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    private static let imageHeight = suggestedHorizontalConstraint(156)
    static let viewHeight = RegaloHeaderView.imageHeight + 80

    override func awakeFromNib() {
        super.awakeFromNib()

        firstLabel.font = UIFont.regular(size: 17)
        secondLabel.font = UIFont.bold(size: 28)
        firstLabel.textColor = UIColor.ijTextBlackColor()
        secondLabel.textColor = UIColor.ijTextBlackColor()

        imageHeightConstraint.constant = RegaloHeaderView.imageHeight
    }
    
}
