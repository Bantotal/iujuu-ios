//
//  ProgressView.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

class ProgressView: UIView {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        leftView.backgroundColor = .white
        rightView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
    }

    func setProgress(percentage: Int, of total: Int) {
        UIView.animate(withDuration: 1.4, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let me = self else { return }
                me.widthConstraint.constant = CGFloat(percentage) * me.frame.width / CGFloat(total)
            }, completion: nil)
    }

}
