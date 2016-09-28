//
//  WelcomeViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Opera

class WelcomeViewController: XLViewController {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        facebookButton.setStyle(.primaryWith(color: .ijDenimBlueColor()))
        createAccountButton.setStyle(.secondary(borderColor: .ijDeepOrangeColor()))
        loginButton.setStyle(.borderless(titleColor: .white))

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    func loginTapped() {
        DataManager.shared.login(username: nil, email: "mbegerez@iujuu.com", password: "1234")?
            .do(onNext: { (user) in
                UIApplication.changeRootViewController(R.storyboard.main().instantiateInitialViewController()!)
                }, onError: { [weak self] (error) in
                    if let error = error as? OperaError {
                        switch error {
                        case let .networking(_, _, response, _):
                            if response?.statusCode == Constants.Network.Unauthorized {
                                self?.showError(UserMessages.Register.loginError)
                                return
                            }
                        default: break
                        }
                    }
                    self?.showError(UserMessages.networkError)
                })
            .subscribe().addDisposableTo(disposeBag)
    }

}
