//
//  ListItemRow.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/23/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Eureka

class ListItemCell: _FieldCell<String>, CellType {
    
    private var bottomSeparator: UIView?
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var inputAccessoryView: UIView? {
        return nil
    }
    
    override func setup() {
        super.setup()
        contentView.layoutMargins = UIEdgeInsets(top: 8, left: Constants.Cells.ListItemMargin, bottom: 8, right: Constants.Cells.ListItemMargin)
        addSeparator()
    }
    
    override func update() {
        super.update()
        titleLabel?.textColor = .ijWarmGreyColor()
        textField.textColor = .ijTextBlackColor()
        titleLabel?.font = UIFont.regular(size: 17)
        textField.font = UIFont.regular(size: 17)
        textField.textAlignment = .left
    }
    
    func addSeparator() {
        bottomSeparator = UIView(frame: CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1))
        contentView.addSubview(bottomSeparator!)
        bottomSeparator?.backgroundColor = .ijSeparatorGrayColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let bottom = bottomSeparator {
            bottom.frame = CGRect(x: Constants.Cells.ListItemMargin, y: frame.height - 1, width: contentView.frame.width - 2 * Constants.Cells.ListItemMargin, height: 1)
        }
    }
    
}

final class ListItemRow:  FieldRow<ListItemCell>, RowType {
    
    required init(tag: String?) {
        super.init(tag: tag)
        placeholderColor = .ijWarmGreyColor()
    }
    
}
