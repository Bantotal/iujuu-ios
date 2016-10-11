//
//  RegaloDetailViewController.swift
//  Iujuu
//
//  Created by user on 9/30/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit
import Eureka
import RealmSwift
import RxSwift
import Opera
import Crashlytics

class RegaloDetailViewController: FormViewController {

    var regalo: Regalo!
    let disposeBag = DisposeBag()

    var comingFromDeeplink: Bool {
        return navigationController?.viewControllers.count == 1
    }

    //MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeader()
        setUpRows()
        setUpStyles()
        setBarRightButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        setUpParticiparButton()
    }

    //MARK: - Navigation bar buttons

    private func setBarRightButtons() {
        let shareRightBarButton = createShareButton()
        var rightBarButtons = [shareRightBarButton]

        let userIsAdministrador = currentUserIsAdministrator()
        if userIsAdministrador && regalo.active && !comingFromDeeplink {
            let editRightBarButton = createEditButton()
            rightBarButtons.append(editRightBarButton)
        }

        self.navigationItem.rightBarButtonItems = rightBarButtons
    }

    private func createShareButton() -> UIBarButtonItem {
        let shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        shareButton.setImage(R.image.iconShare(), for: .normal)
        shareButton.addTarget(self, action: #selector(RegaloDetailViewController.sharePressed), for: .touchUpInside)

        let shareRightBarButton = UIBarButtonItem()
        shareRightBarButton.customView = shareButton
        return shareRightBarButton
    }

    private func createEditButton() -> UIBarButtonItem {
        let editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        editButton.setImage(R.image.iconEdit(), for: .normal)
        editButton.addTarget(self, action: #selector(RegaloDetailViewController.editPressed), for: .touchUpInside)

        let editRightBarButton = UIBarButtonItem()
        editRightBarButton.customView = editButton
        return editRightBarButton
    }

    func sharePressed() {
        let shareString = UserMessages.RegaloDetail.shareMessage.parametrize(Constants.Texts.shareBaseUrl.parametrize(regalo?.codigo ?? ""))
        let activityViewController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }

    func editPressed() {
        let vc = R.storyboard.main.editRegaloNavigationController()!
        (vc.topViewController as? EditRegaloViewController)?.regalo = regalo
        present(vc, animated: true, completion: nil)
    }

    //MARK: - Regalo helper functions

    private func currentUserIsAdministrator() -> Bool {
        let currentUserId = DataManager.shared.userId
        guard let userId = currentUserId, let administratorId = regalo?.usuarioAdministradorId else {
            return false
        }
        return administratorId == userId
    }

    //MARK: - Styles setup

    private func setUpStyles() {
        view.backgroundColor = .ijWhiteColor()
        tableView?.backgroundColor = .ijWhiteColor()
        tableView?.backgroundView = nil
        if comingFromDeeplink {
            addLeftNavigationCancel(withTarget: self, action: #selector(RegaloDetailViewController.cancel))
        }
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        title = UserMessages.RegaloDetail.title
    }

    //MARK: - Table setup

    private func setUpParticiparButton() {
        guard regalo.active else {
            return
        }

        let containerView = UIView()
        let isAdministrator = currentUserIsAdministrator()
        let buttonHeight = suggestedVerticalConstraint(110)

        let participarButton = createParticiparButton(height: buttonHeight)
        let finalizarButton = createFinalizarButton()

        if isAdministrator && !comingFromDeeplink {
            containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: buttonHeight * 2)
            finalizarButton.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: buttonHeight)
            containerView.addSubview(participarButton)
            containerView.addSubview(finalizarButton)
        } else {
            containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: buttonHeight)
            containerView.addSubview(participarButton)
        }

        tableView?.tableFooterView = containerView
    }

    private func createParticiparButton(height: CGFloat) -> ButtonFooter {
        let participarButton = ButtonFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: height))
        participarButton.actionButton.setTitle(UserMessages.RegaloDetail.participar, for: .normal)
        participarButton.onAction = {
            self.sendtoParticipar()
        }

        return participarButton
    }

    private func createFinalizarButton() -> ButtonFooter {
        let finalizarButton = ButtonFooter()
        finalizarButton.actionButton.setTitle(UserMessages.RegaloDetail.finalizar, for: .normal)
        finalizarButton.actionButton.setStyle(.secondary(borderColor: .ijOrangeColor()))
        finalizarButton.onAction = {
            self.finalizarColecta()
        }

        return finalizarButton
    }

    private func sendtoParticipar() {
        guard let regalo = regalo else { return }
        guard DataManager.shared.getCurrentUser() != nil else {
            let welcomeViewController = R.storyboard.onboarding.welcomeViewController()!
            AfterLoginPending.shared.add(pending: { DataManager.shared.joinToRegalo(regalo: regalo) })
            UIApplication.changeRootViewController(welcomeViewController)
            return
        }
        guard comingFromDeeplink else {
            let participarViewController = ParticiparViewController()
            participarViewController.regalo = regalo
            _ = navigationController?.pushViewController(participarViewController, animated: true)
            return
        }

        // from deeplink with user

        LoadingIndicator.show()
        DataManager.shared
            .joinToRegalo(regalo: regalo)
            .do(
                onNext: { [weak self] _ in
                    LoadingIndicator.hide()
                    let homeViewController = R.storyboard.main.homeViewController()!
                    let detailViewController = R.storyboard.main.regaloDetailViewController()!
                    detailViewController.regalo = regalo
                    let participarViewController = ParticiparViewController()
                    participarViewController.regalo = regalo
                    let controllers = [homeViewController, detailViewController, participarViewController]
                    self?.navigationController?.setViewControllers(controllers, animated: true)
                },
                onError: { [weak self] error in
                    LoadingIndicator.hide()
                    Crashlytics.sharedInstance().recordError(error)
                    let alt = (title: UserMessages.errorTitle, message: UserMessages.ParticiparRegalo.couldNotJoinError)
                    self?.showError(error, alternative: alt)
                }
            )
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    private func finalizarColecta() {
        let finalizarViewController = FinalizarColectaViewController()
        finalizarViewController.regalo = regalo
        navigationController?.pushViewController(finalizarViewController, animated: true)
    }

    private func setUpHeader() {
        let headerHeight = suggestedVerticalConstraint(380)
        let regaloHeader = R.nib.regaloDetailHeader.firstView(owner: nil)
        regaloHeader?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight)
        regaloHeader?.setup(regalo: regalo)
        tableView?.tableHeaderView = regaloHeader
    }

    private func setUpRows() {

        form +++ Section()

        <<< LabelRow() {
            $0.title = UserMessages.RegaloDetail.cantidadPersonas(cantidad: regalo.participantes.count)
            if self.currentUserIsAdministrator() && !(self.regalo.participantes.isEmpty) {
                $0.value = UserMessages.RegaloDetail.seeParticipants
            }
        }
        .cellSetup { cell, _ in
            cell.textLabel?.font = .regular(size: 17)
            cell.height = { 60 }
        }
        .onCellSelection { cell, row in
            if self.currentUserIsAdministrator() && !(self.regalo.participantes.isEmpty) {
                let participantesController = ParticipantesViewController()
                participantesController.regalo = self.regalo
                self.navigationController?.pushViewController(participantesController, animated: true)
            }
        }

        let options = regalo.regalosSugeridos
        let totalVotes = getTotalVotes(options: options)

        let selectableSection = SelectableSection<CheckRow<String>> { section in
            var header = HeaderFooterView<IdeaRegalosHeader>(.nibFile(name: "IdeaRegalosHeader", bundle: nil))
            header.height = {
                suggestedVerticalConstraint(60)
            }
            header.onSetupView = { view, _ in
                view.text = UserMessages.RegaloDetail.ideasTitle
            }
            section.header = header
        }

        selectableSection.onSelectSelectableRow  = { [weak self] cell, row in
            guard let selectedValue = row.value else { return }
            if !row.isDisabled {
                self?.sendVote(vote: selectedValue, cell: cell)
            }
        }

        form +++ selectableSection

        for option in options {
            form.last! <<< CheckRow<String>(option.regaloDescription) { lrow in
                lrow.title = option.regaloDescription
                lrow.selectableValue = option.regaloDescription
            }
            .cellUpdate { cell, _ in
                let percentage = Double(option.votos) / totalVotes
                cell.showPercentageBackground(percentage: percentage)
            }
            .cellSetup { cell, _ in
                cell.selectionStyle = .none
                cell.textLabel?.font = .regular(size: 16)
            }
        }
    }

    private func sendVote(vote: String, cell: CheckCell<String>) {
        LoadingIndicator.show()
        DataManager.shared.voteRegalo(regaloId: regalo.id, voto: vote)
        .do(onNext: { [weak self] regalos in
            LoadingIndicator.hide()
            cell.textLabel?.font = .bold(size: 16)
            cell.optionWasSelected = true
            self?.disableSection()
        }, onError: { [weak self] error in
            LoadingIndicator.hide()
            if let error = error as? OperaError {
                self?.showOperaError(error: error)
            } else {
                self?.showError(UserMessages.networkError)
            }
        })
        .subscribe()
        .addDisposableTo(disposeBag)
    }

    private func disableSection() {
        let lastSection = form.last!
        for row in lastSection {
            row.disabled = true
            row.evaluateDisabled()
        }
        lastSection.reload()
    }

    private func showOperaError(error: OperaError) {
        switch error {
        case .networking:
            showError(UserMessages.RegaloDetail.voteError)
        default:
            showError(UserMessages.networkError)
            break
        }
    }

    private func getTotalVotes(options: List<RegaloSugerido>) -> Double {
        var count = 0
        options.forEach { regalo in
            count += regalo.votos
        }
        return Double(count)
    }

    func cancel() {
        // just called when cancelling from deeeplink
        guard let confirmViewController = R.storyboard.invitedFlow.confirmationCodeViewController() else { return }
        confirmViewController.regalo = regalo
        UIApplication.changeRootViewController(confirmViewController)
    }

}
