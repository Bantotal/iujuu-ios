//
//  ButtonFooter.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/23/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import XLSwiftKit
import RxSwift

class ButtonFooter: OwnerView {

    @IBOutlet weak var actionButton: UIButton!

    private let disposeBag = DisposeBag()
    var onAction: () -> () = {} {
        didSet {
            actionButton.rx.tap.subscribe(onNext: onAction).addDisposableTo(disposeBag)
        }
    }

    override func viewForContent() -> UIView? {
        return R.nib.buttonFooter.firstView(owner: self)
    }

    override func setup() {
        super.setup()
        contentView.backgroundColor = .clear
        actionButton.setStyle(.primary)
        actionButton.setTitle(UserMessages.Onboarding.register, for: .normal)
    }

}
