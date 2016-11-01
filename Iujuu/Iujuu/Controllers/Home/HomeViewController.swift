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
import XLSwiftKit

class HomeViewController: XLTableViewController {

    @IBOutlet weak var createColectaButton: UIButton!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingBalloonConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingBalloonConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBalloonConstraint: NSLayoutConstraint!
    @IBOutlet weak var balloonHeightConstraint: NSLayoutConstraint!

    var regalos: [Regalo] = []
    var emptyView: EmptyHomeView?

    fileprivate var selectedCell: RegaloCell?
    fileprivate let customAnimationController = HomeRegaloTransitionController()

    private let headerHeight = Int(suggestedHorizontalConstraint(180, q6: 0.95, q5: 0.9, q4: 0.9))
    private let emptyViewHeight = 400

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        balloonHeightConstraint.constant = suggestedHorizontalConstraint(130)
        setTableView()
        setupCreateColectaButton()
        DataManager.shared.getRegalos()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] regalos in
                self?.setEmptyViewState(hidden: regalos.count != 0)
                let wasEmpty = self?.regalos.isEmpty ?? true
                self?.regalos = regalos
                if wasEmpty && !regalos.isEmpty {
                    self?.tableView.reloadDataAnimated(completion: nil)
                } else {
                    self?.tableView.reloadData()
                }
            }).subscribe().addDisposableTo(disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = .ijBlackColor()
        DataManager.shared.reloadRegalos()
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(R.nib.regaloCell(), forCellReuseIdentifier: R.reuseIdentifier.regaloCell.identifier)
        tableView.backgroundColor = .clear
        view.backgroundColor = .white
        setEmptyView()
        setTableHeader()

        tableView.rx.contentOffset.asObservable().do(onNext: { [weak self] offset in
            // starts on 0, from 50 to 160 we want to move
            // top constraint starts on -20
            // leading and trailing constraints start on 0; move to negative
            let startOffset: CGFloat = 60.0
            let endOffset: CGFloat = suggestedHorizontalConstraint(180.0, q6: 0.95, q5: 0.9, q4: 0.9)
            let translation = min(max(offset.y - startOffset, 0), endOffset - startOffset)
            self?.leadingBalloonConstraint.constant = -translation * 0.5
            self?.trailingBalloonConstraint.constant = -translation * 0.5
            self?.topBalloonConstraint.constant = -20 - translation
        }).subscribe().addDisposableTo(disposeBag)
    }

    private func setEmptyView() {
        emptyView = EmptyHomeView(frame: CGRect(x: 0, y: headerHeight, width: Int(view.bounds.width), height: emptyViewHeight))

        emptyView?.nuevaColectaAction = {
            self.getAccounts()
        }

        emptyView?.ingresarCodigoAction = {
            self.sendToIngresarCodigo()
        }

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: headerHeight + emptyViewHeight))
        containerView.addSubview(emptyView!)

        tableView.backgroundView = containerView
    }

    private func setTableHeader() {
        let homeHeader = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: headerHeight))
        homeHeader.settingsTappedAction = { [weak self] in
            self?.settingsTapped()
        }
        tableView.tableHeaderView = homeHeader
    }

    private func setupCreateColectaButton() {
        createColectaButton.setStyle(.primary)
        createColectaButton.layer.cornerRadius = 0
        createColectaButton.setTitle(UserMessages.Home.createColecta, for: .normal)
        createColectaButton.addTarget(self, action: #selector(createColectaTapped), for: .touchUpInside)
    }

    func setEmptyViewState(hidden: Bool) {
        emptyView?.isHidden = hidden
        tableView.isScrollEnabled = hidden
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
        selectedCell = tableView.cellForRow(at: indexPath) as? RegaloCell
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

extension HomeViewController: UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let selectedCell = selectedCell {
            if fromVC is HomeViewController && toVC is RegaloDetailViewController {
                customAnimationController.selectedCell = selectedCell
                return customAnimationController
            } else if fromVC is RegaloDetailViewController && toVC is HomeViewController {
                customAnimationController.selectedCell = selectedCell
                return customAnimationController
            }

        }

        return nil
    }
}
