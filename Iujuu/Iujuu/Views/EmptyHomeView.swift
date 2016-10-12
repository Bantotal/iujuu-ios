//
//  EmptyHomeView.swift
//  Iujuu
//
//  Created by user on 9/27/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import RxSwift
import XLSwiftKit

class EmptyHomeView: UIView {

    let disposeBag = DisposeBag()

    //MARK - UI Outlets
    @IBOutlet weak var nuevaColectaButton: UIButton!
    @IBOutlet weak var ingresarCodigoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!

    //MARK: - UI Constraints

    @IBOutlet weak var buttonsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsToTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!

    var nuevaColectaAction : () -> () = {} {
        didSet {
            nuevaColectaButton.rx.tap.subscribe(onNext: nuevaColectaAction).addDisposableTo(disposeBag)
        }
    }

    var ingresarCodigoAction : () -> () = {} {
        didSet {
            ingresarCodigoButton.rx.tap.subscribe(onNext: ingresarCodigoAction).addDisposableTo(disposeBag)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setButtonsStyle()
        setTitleStyle()
        setConstraints()
    }

    private func setButtonsStyle() {
        nuevaColectaButton.setStyle(.primary)

        ingresarCodigoButton.setStyle(.border(borderColor: UIColor.ijMainOrangeColor()))
        ingresarCodigoButton.layer.borderWidth = 1
        ingresarCodigoButton.titleLabel?.textColor = UIColor.ijBlackColor()
    }

    private func setTitleStyle() {
        titleLabel.font = UIFont.regular(size: 18)
    }

    private func setConstraints() {
        buttonsToTitleConstraint.constant = suggestedVerticalConstraint(40)
        buttonsHeightConstraint.constant = suggestedVerticalConstraint(70)
        imageHeightConstraint.constant = suggestedVerticalConstraint(160)
        imageWidthConstraint.constant = imageHeightConstraint.constant
    }
}
