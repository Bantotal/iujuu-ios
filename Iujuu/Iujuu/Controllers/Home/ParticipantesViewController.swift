//
//  ParticipantesViewController.swift
//  Iujuu
//
//  Created by user on 10/7/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import Eureka

class ParticipantesViewController: FormViewController {

    var users: [User]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRows()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        title = UserMessages.Participantes.title
    }

    private func setUpRows() {
        form +++ Section(UserMessages.Participantes.participantesTitle)

        users.map { "\($0.nombre) \($0.apellido)" }
            .forEach { participante in
                form.last!
                    <<< LabelRow() {
                        $0.title = participante
                    }
                    .cellSetup { cell, _ in
                        cell.textLabel?.font = UIFont.regular(size: 17)
                        cell.height = { 60 }
                    }
            }
    }
}
