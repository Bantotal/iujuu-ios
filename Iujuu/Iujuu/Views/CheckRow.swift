//
//  CheckRow.swift
//  Iujuu
//
//  Created by user on 10/3/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Eureka

public final class CheckRow<T: Equatable>: Row<CheckCell<T>>, SelectableRowType, RowType {
    public var selectableValue: T?
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public class CheckCell<T: Equatable> : Cell<T>, CellType {

    var selectionBackgroundView: UIView?
    var animationDuration: TimeInterval = 0.9
    var optionWasSelected = false

    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy public var trueImage: UIImage = {
        return R.image.selectedCircle()!
    }()

    lazy public var falseImage: UIImage = {
        return R.image.unselectedCircle()!
    }()

    public override func update() {
        super.update()
        accessoryType = .none
        optionWasSelected ? setSelectedImage() : setUnselectedImage()
    }

    public func setSelectedImage() {
        accessoryView = UIImageView(image: trueImage)
    }

    public func setUnselectedImage() {
        accessoryView = UIImageView(image: falseImage)
    }

    public override func setup() {
        super.setup()
        selectionBackgroundView = UIView()
        selectionBackgroundView?.frame = CGRect(x: 0, y: 0, width: 0, height: frame.size.height)
        selectionBackgroundView?.backgroundColor = UIColor.ijAccentRedLightColor()
        addSubview(selectionBackgroundView!)
        sendSubview(toBack: selectionBackgroundView!)
    }

    public override func didSelect() {
        row.reload()
        row.select()
        row.deselect()
    }

    func showPercentageBackground(percentage: Double) {
        let newWidth = (frame.size.width - (accessoryView?.frame.width)!) * CGFloat(percentage)
        UIView.animate(withDuration: animationDuration) {
            self.selectionBackgroundView?.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.frame.size.height)
        }
    }

}
