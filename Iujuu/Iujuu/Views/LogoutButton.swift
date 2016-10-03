//
//  logoutButton.swift
//  Iujuu
//
//  Created by user on 9/29/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import RxSwift
import XLSwiftKit

class LogoutButton: OwnerView {

    @IBOutlet weak var logoutButton: UIButton!

    private let disposeBag = DisposeBag()
    var onAction: () -> () = {} {
        didSet {
            logoutButton.rx.tap.subscribe(onNext: onAction).addDisposableTo(disposeBag)
        }
    }

    override func viewForContent() -> UIView? {
        return R.nib.logoutButton.firstView(owner: self)
    }

    override func setup() {
        super.setup()
        logoutButton.setTitleColor(UIColor.ijAccentRedColor(), for: UIControlState.normal)
        logoutButton.titleLabel?.font = UIFont.regular(size: 16)
    }

}
