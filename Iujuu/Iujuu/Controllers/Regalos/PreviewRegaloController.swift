//
//  PreviewRegaloController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import XLSwiftKit
import SwiftDate
import RxSwift
import Opera

fileprivate let addIdeaRowTag = "addIdeaRowTag"
fileprivate let ideaSectionTag = "ideaSectionTag"

class RegaloPreviewViewController: FormViewController {

    var regalo: RegaloSetup!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let name = regalo.name,
            let motivo = regalo.motivo,
            let amount = regalo.amount,
            let perPerson = regalo.suggestedPerPerson,
            let closeDate = regalo.closingDate else { return }

        setupTableView()
        let labelRowHeight: CGFloat = 35

        form +++ Section() { section in
            var header = HeaderFooterView<RegaloHeaderView>(.nibFile(name: "RegaloHeaderView", bundle: nil))
            header.onSetupView = { view, _ in
                view.imageView.image = Motivo(rawValue: motivo)?.image()
                view.firstLabel.text = NSLocalizedString("{0} de", comment: "").parametrize(motivo)
                view.secondLabel.text = name
            }
            header.height = { RegaloHeaderView.viewHeight }
            section.header = header
        }
            <<< IJLabelRow() {
                    $0.title = UserMessages.RegaloPreview.amountText
                    $0.value = Constants.Formatters.intCurrencyFormatter.string(from: NSNumber(value: amount))
                }.cellSetup { (cell, row) in
                        cell.height = { labelRowHeight }
                }
            <<< IJLabelRow() {
                    $0.title = UserMessages.RegaloPreview.perPersonText
                    $0.value = Constants.Formatters.intCurrencyFormatter.string(from: NSNumber(value: perPerson))
                }.cellSetup { (cell, row) in
                        cell.height = { labelRowHeight }
                }
            +++ Section() { section in
                section.setEmptyFooterOfHeight(height: 0.01)
                section.setEmptyHeaderOfHeight(height: 0.01)
            }
            <<< IJLabelRow() {
                    $0.title = UserMessages.RegaloPreview.closeDateText
                    $0.value = closeDate.dateString()
                }.cellSetup { (cell, row) in
                    cell.addSeparators()
                    cell.height = { 64 }
                }
            +++ Section() { [weak self] section in
                guard let me = self else { return }
                var header = HeaderFooterView<SubtitleView>(.nibFile(name: "SubtitleView", bundle: nil))
                header.onSetupView = { view, _ in
                    view.titleLabel.text = UserMessages.RegaloPreview.regaloIdeasTitle
                    view.subtitleLabel.text = UserMessages.RegaloPreview.regaloIdeasHelp
                }
                header.height = { suggestedVerticalConstraint(80, q6: 0.95, q5: 0.9) }
                section.header = header

                var footer = HeaderFooterView<UIView>(HeaderFooterProvider.callback({ () -> UIView in
                    //TODO: Setup button view
                    let footer = ButtonFooter()
                    footer.actionButton.setTitle(UserMessages.RegaloPreview.buttonText, for: .normal)
                    footer.actionButton.addTarget(me, action: #selector(RegaloPreviewViewController.nextTapped), for: .touchUpInside)
                    return footer
                }))

                footer.height = { 100 }
                section.footer = footer
                section.tag = ideaSectionTag
        }
            <<< ListItemRow(addIdeaRowTag) {
                $0.title = "+"
                $0.placeholder = UserMessages.RegaloPreview.addIdea
            }.cellSetup { (cell, row) in
                cell.titleLabel?.font = .regular(size: 18)
                cell.textField.font = .regular(size: 18)
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        (navigationController as? IURegaloNavigationController)?.hideProgressBar()
    }

    //MARK: Setting up
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func setUpNavigationBar() {
        let bar = navigationController?.navigationBar
        navigationItem.backBarButtonItem?.title = UserMessages.back
        title = UserMessages.RegaloPreview.title
        bar?.barTintColor = .white
        bar?.tintColor = .ijGreyishBrownColor()
    }

    func setupTableView() {
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = .white
    }

    // MARK: Actions
    func addItem(with value: String) {
        guard var section = form.sectionBy(tag: ideaSectionTag) else { return }
        let row = ListItemRow() {
            $0.value = value
            $0.title = "●"
        }.cellSetup { (cell, row) in
            cell.textField.isUserInteractionEnabled = false
        }
        section.insert(row, at: section.count - 1)
    }

    func nextTapped() {
        LoadingIndicator.show()
        guard let userId = DataManager.shared.user?.id,
            let motivo = regalo.motivo,
            let name = regalo.name,
            let date = regalo.closingDate,
            let amount = regalo.amount,
            let perPersonAmount = regalo.suggestedPerPerson,
            let account = regalo.account else { return }
        Router.Regalo.Create(userId: userId, motivo: motivo, name: name, closeDate: date,
                             targetAmount: amount, perPersonAmount: perPersonAmount)
            .rx_object("regalo")
            .do(onNext: { [weak self] (regalo: Regalo) in
                LoadingIndicator.hide()
                GCDHelper.runOnMainThread {
                    try? regalo.save()
                }
                self?.performSegue(withIdentifier: R.segue.regaloPreviewViewController.showRegaloSetupCompleted.identifier, sender: self)
            }, onError: { [weak self] (error) in
                LoadingIndicator.hide()

                self?.showError("No se pudo dar de alta el regalo. Por favor, inténtelo más tarde")
        }).subscribe().addDisposableTo(disposeBag)
    }

    // MARK: Overrides
    override func textInputShouldReturn<T>(_ textInput: UITextInput, cell: Cell<T>) -> Bool {
        let result = super.textInputShouldReturn(textInput, cell: cell)
        if cell.row.tag == addIdeaRowTag {
            if let value = cell.row.value as? String, !value.isEmpty {
                addItem(with: value)
                cell.row.value = nil
                (cell as? ListItemCell)?.textField.text = nil
            }
        }
        return result
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //TODO: set code
        (segue.destination as? ShareRegaloViewController)?.code = "12345"
    }

}

// MARK: TableView editing
extension RegaloPreviewViewController {

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if let section = form.sectionBy(tag: ideaSectionTag), indexPath.section == section.index && indexPath.row != section.count - 1 {
            return .delete
        }
        return .none
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            form[indexPath.section].remove(at: indexPath.row)
        }
    }

}

extension UserMessages.RegaloPreview {

    static let title = NSLocalizedString("Nueva colecta", comment: "")
    static let addIdea = NSLocalizedString("Agregar idea", comment: "")
    static let buttonText = NSLocalizedString("Crear colecta", comment: "")
    static let regaloIdeasTitle = NSLocalizedString("Ideas de regalo", comment: "")
    static let regaloIdeasHelp = NSLocalizedString("Los participantes podrán votar entre las opciones", comment: "")
    static let closeDateText = NSLocalizedString("Fecha de cierre", comment: "")
    static let perPersonText = NSLocalizedString("por persona", comment: "")
    static let amountText = NSLocalizedString("Objetivo", comment: "")

}
