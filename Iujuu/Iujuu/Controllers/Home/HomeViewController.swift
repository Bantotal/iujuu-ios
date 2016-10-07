//
//  HomeViewController.swift
//  Iujuu
//
//  Created by user on 9/27/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import OAuthSwift
import Opera
import RxSwift

class HomeViewController: XLTableViewController {

    @IBOutlet weak var balloonsImage: UIImageView!
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createColectaButton: UIButton!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!

    var regalos: [Regalo] = []
    var emptyView: EmptyHomeView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setupCreateColectaButton()
        DataManager.shared.getRegalos()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] regalos in
                self?.setEmptyViewState(hidden: regalos.count != 0)
                self?.regalos = Array(regalos)
                print(self?.regalos.count)
                self?.tableView.reloadData()
            }).subscribe().addDisposableTo(disposeBag)
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(R.nib.regaloCell(), forCellReuseIdentifier: R.reuseIdentifier.regaloCell.identifier)
        tableView.backgroundColor = .white
        setEmptyView()
    }

    private func setEmptyView() {
        emptyView = R.nib.emptyHomeView.firstView(owner: nil)

        emptyView?.nuevaColectaAction = {
            self.getAccounts()
        }

        emptyView?.ingresarCodigoAction = {
            self.sendToIngresarCodigo()
        }

        tableView.backgroundView = emptyView
    }

    private func setupCreateColectaButton() {
        createColectaButton.setStyle(.primary)
        createColectaButton.layer.cornerRadius = 0
        createColectaButton.setTitle(UserMessages.Home.createColecta, for: .normal)
        createColectaButton.addTarget(self, action: #selector(createColectaTapped), for: .touchUpInside)
    }

    func setEmptyViewState(hidden: Bool) {
        emptyView?.isHidden = hidden
        createColectaButton.isHidden = !hidden
        tableBottomConstraint.constant = hidden ? 68 : 0
    }

    private func sendToCrearColecta(_ accounts: [Account]) {
        let viewController = R.storyboard.createRegalo.regaloSetupNavigationController()!
        (viewController.topViewController as? RSChooseAccountViewController)!.accounts = accounts
        present(viewController, animated: true, completion: nil)
    }

    func createColectaTapped() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: UserMessages.Home.actionCreateColecta, style: .default, handler: { [weak self] _ in
            self?.getAccounts()
        }))
        controller.addAction(UIAlertAction(title: UserMessages.Home.actionInsertCode, style: .default, handler: { [weak self] _ in
            self?.sendToIngresarCodigo()
        }))

        controller.addAction(UIAlertAction(title: UserMessages.cancel, style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)


    }

    private func sendToIngresarCodigo() {
        let viewController = R.storyboard.createRegalo.joinRegaloNavigationController()!
        present(viewController, animated: true, completion: nil)
    }

    private func getAccounts() {

        func getAccountsAuthenticated() {
            DataManager.shared.getAccounts().do(onNext: { [weak self] accounts in
                LoadingIndicator.hide()
                if accounts.isEmpty {
                    self?.showError(UserMessages.Home.needAccounts)
                } else {
                    self?.sendToCrearColecta(accounts)
                }
            }, onError: { [weak self] error in
                LoadingIndicator.hide()
                if let error = error as? OperaError {
                    switch error {
                    case let .networking(_, _, response, _):
                        if response?.statusCode == Constants.Network.Unauthorized {
                            // restart process without token
                            self?.getAccounts()
                            return
                        }
                    default:
                        break
                    }
                    print(error.debugDescription)
                    print(error.description)
                }
                self?.showError(UserMessages.Home.galiciaAccountError)
            }).subscribe().addDisposableTo(disposeBag)
        }

        LoadingIndicator.show()
        if !SessionController.hasGaliciaToken() {
            SessionController.sharedInstance.getOAuthToken(urlHandler: self) { [weak self] error in
                if let _ = error {
                    LoadingIndicator.hide()
                    self?.showError(UserMessages.Home.needAccounts)
                } else {
                    getAccountsAuthenticated()
                }
            }
        } else {
            getAccountsAuthenticated()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        setUp()
    }

    private func setUp () {
        setTitle()
        setSettingsButton()
    }

    private func setTitle() {
        titleLabel.font = UIFont.regular(size: 20)
        titleLabel.textColor = UIColor.ijGreyishBrownColor()
    }

    private func setSettingsButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.settingsTapped))
        settingsIcon.addGestureRecognizer(tap)
        settingsIcon.isUserInteractionEnabled = true
    }

    func settingsTapped() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return regalos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RegaloCell! = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.regaloCell.identifier) as? RegaloCell
        cell.setup(regalo: regalos[indexPath.section])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RegaloCell.rowHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailController = RegaloDetailViewController()
        detailController.regalo = regalos[indexPath.section]
        navigationController?.pushViewController(detailController, animated: true)
    }

}

extension HomeViewController: OAuthSwiftURLHandlerType {

    func handle(_ url: URL) {
        let webViewController = R.storyboard.main.oAuthViewController()!
        webViewController.request = URLRequest(url: url)
        present(webViewController, animated: true, completion: nil)
    }

}
