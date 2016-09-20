//
//  InitialViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/19/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation

class InitialViewController: XLViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Router.Login(username: "yo", email: nil, password: "yo123").rx_anyObject().do(onNext: { object in
            print(object)
        }, onError: { error in
            print(error)
        }).subscribe().addDisposableTo(disposeBag)
    }
}
