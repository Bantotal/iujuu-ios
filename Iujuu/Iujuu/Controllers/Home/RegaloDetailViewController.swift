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
    var participarButton: ButtonFooter?
    
    private struct RowTags {
        static let participations = "participations"
    }

    let participarFooterHeight = suggestedVerticalConstraint(140)

    private var regaloObservableToken: NotificationToken?

    //MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeader()
        setUpRows()
        setUpStyles()
        setBarRightButtons()
        observeRegaloChanges()
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
        if userIsAdministrador && regalo.active {
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
        let buttonHeight = participarFooterHeight

        participarButton = createParticiparButton(height: buttonHeight)
        let finalizarButton = createFinalizarButton()

        if isAdministrator {
            containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: buttonHeight * 2)
            finalizarButton.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: buttonHeight)
            containerView.addSubview(participarButton!)
            containerView.addSubview(finalizarButton)
        } else {
            containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: buttonHeight)
            containerView.addSubview(participarButton!)
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
        let participarViewController = ParticiparViewController()
        participarViewController.regalo = regalo
        _ = navigationController?.pushViewController(participarViewController, animated: true)
    }

    private func finalizarColecta() {
        let finalizarViewController = FinalizarColectaViewController()
        finalizarViewController.regalo = regalo
        navigationController?.pushViewController(finalizarViewController, animated: true)
    }

    private func setUpHeader(animated: Bool = true) {
        let headerHeight = suggestedVerticalConstraint(340)
        let regaloHeader = R.nib.regaloDetailHeader.firstView(owner: nil)
        regaloHeader?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight)
        regaloHeader?.setup(regalo: regalo, animated: animated)
        tableView?.tableHeaderView = regaloHeader
    }

    private func updateFormFrom(regalo: Regalo) {
        (tableView?.tableHeaderView as? RegaloDetailHeader)?.setup(regalo: regalo, animated: false)

        let labelRow: LabelRow! = form.rowBy(tag: RowTags.participations) as? LabelRow
        labelRow.updateCell()

        let options = regalo.regalosSugeridos
        let optionsTags = options.map { $0.regaloDescription }
        let totalVotes = getTotalVotes(options: options)

        let oldOptionTags = form.last?.flatMap { $0.tag } ?? []
        let newOptionTags = optionsTags.filter { !oldOptionTags.contains($0) }
        let updateOptionTags = optionsTags.filter { oldOptionTags.contains($0) }

        for option in options {
            if newOptionTags.contains(option.regaloDescription) {
                form.last! <<< createOptionRow(regaloDescription: option.regaloDescription, votes: option.votos, totalVotes: totalVotes)
            } else if updateOptionTags.contains(option.regaloDescription) {
                let optionRow = form.rowBy(tag: option.regaloDescription) as? CheckRow<String>
                optionRow?.title = option.regaloDescription
                optionRow?.selectableValue = option.regaloDescription
                let percentage = Double(option.votos) / totalVotes
                optionRow?.cell.showPercentageBackground(percentage: percentage)
            } else { // delete
                let optionRow = form.rowBy(tag: option.regaloDescription) as? CheckRow<String>
                form[form.count - 1].remove(at: optionRow!.indexPath!.row)
            }
        }
    }

    private func setUpRows() {

        form +++ Section()

        <<< LabelRow(RowTags.participations)
        .cellUpdate { [weak self] _, row in
            guard let me = self else { return }
            row.title = UserMessages.RegaloDetail.cantidadPersonas(cantidad: me.regalo.participantes.count)
            if me.currentUserIsAdministrator() && !(me.regalo.participantes.isEmpty) {
                row.value = UserMessages.RegaloDetail.seeParticipants
            }
        }
        .cellSetup { cell, _ in
            cell.textLabel?.font = .regular(size: 17)
            cell.height = { 60 }
        }
        .onCellSelection { [weak self] cell, row in
            guard let me = self else { return }
            if me.currentUserIsAdministrator() && !(me.regalo.participantes.isEmpty) {
                LoadingIndicator.show()
                let users: [Observable<User>] = me.regalo.participantes.map({ str in
                    return DataManager.shared.getUser(id: Int(str.string)!)
                })
                Observable.from(users)
                    .merge()
                    .toArray()
                    .do(onNext: { [weak self] users in
                        LoadingIndicator.hide()
                        self?.showParticipants(users)
                    }, onError: { [weak self] error in
                        LoadingIndicator.hide()
                        self?.showError(error, alternative: (title: UserMessages.errorTitle, message: UserMessages.RegaloDetail.participantError))
                    })
                    .subscribe().addDisposableTo(me.disposeBag)
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
            form.last! <<< createOptionRow(regaloDescription: option.regaloDescription, votes: option.votos, totalVotes: totalVotes)
        }
    }

    private func createOptionRow(regaloDescription: String, votes: Int, totalVotes: Double) -> CheckRow<String> {
        return CheckRow<String>(regaloDescription) { lrow in
                lrow.title = regaloDescription
                lrow.selectableValue = regaloDescription
            }
            .cellUpdate { cell, _ in
                let percentage = Double(votes) / totalVotes
                cell.showPercentageBackground(percentage: percentage)
            }
            .cellSetup { cell, _ in
                cell.selectionStyle = .none
                cell.textLabel?.font = .regular(size: 16)
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

    private func showParticipants(_ participants: [User]) {
        let participantesController = ParticipantesViewController()
        participantesController.users = participants
        navigationController?.pushViewController(participantesController, animated: true)
    }

    func observeRegaloChanges() {
        regaloObservableToken = RealmManager.shared.defaultRealm.objects(Regalo.self)
            .addNotificationBlock { [weak self] regaloChanges in
                guard let me = self else { return }
                switch regaloChanges {
                case let .update(regalos, _, _, _):
                    guard let regalo = regalos.filter("id == \(me.regalo.id)").first else { return }
                    if me.isViewLoaded && me.view.window != nil {
                        me.updateFormFrom(regalo: regalo)
                    }
                default:
                    break
                }
            }
    }

    deinit {
        regaloObservableToken?.stop()
    }

}
