//
//  IJLabelRow.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Eureka

class IJLabelCell: LabelCell {

    private var topSeparator: UIView?
    private var bottomSeparator: UIView?

    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setup() {
        super.setup()
        textLabel?.font = .regular(size: 17)
        detailTextLabel?.font = .bold(size: 17)
    }

    override func update() {
        super.update()
        textLabel?.textColor = .ijTextBlackColor()
        detailTextLabel?.textColor = .ijBlackColor()
    }

    func addSeparators() {
        topSeparator = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1))
        bottomSeparator = UIView(frame: CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1))

        contentView.addSubview(topSeparator!)
        contentView.addSubview(bottomSeparator!)

        topSeparator?.backgroundColor = .ijSeparatorGrayColor()
        bottomSeparator?.backgroundColor = .ijSeparatorGrayColor()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let top = topSeparator {
            top.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 1)
        }
        if let bottom = bottomSeparator {
            bottom.frame = CGRect(x: 0, y: frame.height - 1, width: contentView.frame.width, height: 1)
        }
    }

}

final class IJLabelRow: Row<IJLabelCell>, RowType {

    required init(tag: String?) {
        super.init(tag: tag)
    }

}
