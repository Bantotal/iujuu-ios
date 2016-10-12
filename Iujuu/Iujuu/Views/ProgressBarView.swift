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
    let fullColor = UIColor.ijAccentRedColor()
    let remainingColor = UIColor.ijAccentRedLightColor()
    let completedColor = UIColor.ijGreenColor()
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
        let percentageToShow = percentageFull > 1 ? 1 : percentageFull

        let fullBarWidth = frame.width
        let barHeight = frame.height

        let fullView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: barHeight))
        fullView.backgroundColor = percentageToShow == 1 ? completedColor : fullColor
        fullView.layer.cornerRadius = borderRadius

        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: fullBarWidth, height: barHeight))
        emptyView.backgroundColor = remainingColor
        emptyView.layer.cornerRadius = borderRadius

        addSubview(emptyView)
        addSubview(fullView)

        let percentageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: barHeight))
        percentageLabel.textAlignment = .left
        percentageLabel.font = .regular(size: 15)
        percentageLabel.text = "\(Int(percentageToShow * 100))%"

        if percentageToShow < 1 && showPercentageLabel {
            addSubview(percentageLabel)
        }

        UIView.animate(withDuration: animationDuration) {
            fullView.frame = CGRect(x: 0, y: 0, width: fullBarWidth * CGFloat(percentageToShow), height: barHeight)
            if percentageToShow != 1 && self.showPercentageLabel {
                percentageLabel.frame = CGRect(x: fullView.frame.width + self.labelOffset, y: 0, width: self.labelOffset + fullBarWidth * CGFloat(1 - percentageToShow), height: barHeight)
            }
        }
    }

}
