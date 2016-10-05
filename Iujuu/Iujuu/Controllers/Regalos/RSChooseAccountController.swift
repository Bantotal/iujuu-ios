//
//  RSChooseAccountController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/26/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

class RSChooseAccountViewController: BaseRegaloSetupController {

    var selectedIndex = 0
    let reuseIdentifier = "cellReuseIdentifier"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    var accounts: [Account] = []

    fileprivate let selectedImage = R.image.radioFull()
    fileprivate let unselectedImage = R.image.radioEmpty()
    fileprivate var selectedAccount: Account?
    fileprivate let rowHeight: CGFloat = 56

    override func viewDidLoad() {
        super.viewDidLoad()
        regalo = RegaloSetup()

        setupTableView()

        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(nextTapped)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: UserMessages.back, style: .done, target: self, action: #selector(backTapped))

        titleLabel.text = UserMessages.RegalosSetup.accountText
        titleLabel.textColor = textColor
        titleLabel.font = .regular(size: 22)
        titleLabel.textAlignment = .left

        descriptionLabel.text = UserMessages.RegalosSetup.accountHelp
        descriptionLabel.textColor = textColor
        descriptionLabel.font = .regular(size: 16)
        descriptionLabel.numberOfLines = 0

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 1)
        selectedAccount = accounts.first
        tableViewHeightConstraint.constant = CGFloat(tableView.numberOfRows(inSection: 0)) * rowHeight + CGFloat(16)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
    }

    func nextTapped() {
        if selectedAccount != nil {
            regalo.account = selectedAccount
            performSegue(withIdentifier: R.segue.rSChooseAccountViewController.showToStartRegaloSetup.identifier, sender: self)
        } else {
            showError(UserMessages.RegalosSetup.accountError)
        }
    }

    func backTapped() {
        dismiss(animated: true, completion: nil)
    }

}

extension RSChooseAccountViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        let account = accounts[indexPath.row]
        cell?.imageView?.image = account == selectedAccount ? selectedImage : unselectedImage

        cell?.textLabel?.text = "\(UserMessages.RegalosSetup.balance): \(account.balance) \(account.currency)"
        cell?.detailTextLabel?.text = account.cbu

        configure(cell: cell!)
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAccount = accounts[indexPath.row]
        tableView.reloadData()
    }

    func configure(cell: UITableViewCell) {
        cell.textLabel?.font = .regular(size: 18)
        cell.detailTextLabel?.font = .regular(size: 14)
        cell.textLabel?.textColor = textColor
        cell.detailTextLabel?.textColor = textColor
        cell.contentView.layoutMargins.left = 44
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }

}
