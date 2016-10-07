//
//  ProgressBarView.swift
//  Iujuu
//
//  Created by user on 9/30/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {

    //MARK:  - Configurable options
    var fullColor = UIColor.red
    var remainingColor = UIColor.gray
    var showPercentageLabel = true
    var borderRadius: CGFloat = 4
    var animationDuration: TimeInterval = 0.9

    //MARK:  - private constants
    private let remainingViewOffet: CGFloat = 5
    private let labelOffset: CGFloat = 7

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setProgress(percentageFull: Double) {
        let fullBarWidth = frame.width
        let barHeight = frame.height

        let fullView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: barHeight))
        fullView.backgroundColor = fullColor
        fullView.layer.cornerRadius = borderRadius

        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: fullBarWidth, height: barHeight))
        emptyView.backgroundColor = remainingColor
        emptyView.layer.cornerRadius = borderRadius

        addSubview(emptyView)
        addSubview(fullView)

        let percentageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: barHeight))
        percentageLabel.textAlignment = .left
        percentageLabel.font = .regular(size: 15)
        percentageLabel.text = "\(Int(percentageFull * 100))%"

        if percentageFull != 1 && showPercentageLabel {
            addSubview(percentageLabel)
        }

        UIView.animate(withDuration: animationDuration) {
            fullView.frame = CGRect(x: 0, y: 0, width: fullBarWidth * CGFloat(percentageFull), height: barHeight)
            if percentageFull != 1 && self.showPercentageLabel {
                percentageLabel.frame = CGRect(x: fullView.frame.width + self.labelOffset, y: 0, width: self.labelOffset + fullBarWidth * CGFloat(1 - percentageFull), height: barHeight)
            }
        }
    }

}
