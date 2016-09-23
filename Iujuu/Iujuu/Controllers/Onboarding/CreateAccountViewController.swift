//
//  CreateAccountViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class CreateAccountViewController: FormViewController {

    var _prefersStatusBarHidden = true
    override var prefersStatusBarHidden: Bool {
        return _prefersStatusBarHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftNavigationCancel(withTarget: self, action: #selector(Progress.cancel))
        setupForm()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _prefersStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
        let footer = ButtonFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        tableView?.setFooterAtBottom(footer, tableHeight: view.bounds.height - (28 * 2))

        footer.onAction = {
            UIApplication.changeRootViewController(R.storyboard.createRegalo().instantiateInitialViewController()!)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func cancel() {
        dismiss(animated: true, completion: nil)
    }

    private func setupForm() {
        let form = Form()
        form +++ Section()
            <<< NameRow() {
                $0.title = UserMessages.firstName
                $0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .continue, defaultKeyboardType: .done)
            }
            <<< NameRow() {
                $0.title = UserMessages.lastname
                $0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .continue, defaultKeyboardType: .done)
            }
            <<< EmailRow() {
                $0.placeholder = nil
                $0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .continue, defaultKeyboardType: .done)
            }
            <<< GenericPasswordRow()
        self.form = form
    }

}
