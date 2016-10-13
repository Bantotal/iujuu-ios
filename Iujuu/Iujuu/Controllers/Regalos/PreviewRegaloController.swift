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
import SwiftyJSON

fileprivate let addIdeaRowTag = "addIdeaRowTag"
fileprivate let ideaSectionTag = "ideaSectionTag"

class RegaloPreviewViewController: FormViewController {

    var regalo: RegaloSetup!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let descripcion = regalo.descripcion,
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
                view.firstLabel.text = descripcion
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
        guard let userId = DataManager.shared.userId,
            let motivo = regalo.motivo,
            let descripcion = regalo.descripcion,
            let date = regalo.closingDate,
            let amount = regalo.amount,
            let perPersonAmount = regalo.suggestedPerPerson,
            let account = regalo.account else {
                print("Error with regalo setup")
                return
        }
        let regalosSugeridos = form.sectionBy(tag: ideaSectionTag)?.map({ $0.baseValue as? String }).filter { $0 != nil} as? [String]
        LoadingIndicator.show()

        DataManager.shared.chooseAccount(cuentaId: account.id, amount: amount, date: date, text: descripcion).do(onNext: { [weak self] element in
            guard let me = self else { return }
            let json = JSON(element)
            guard let accountId = json["id"].string else {
                LoadingIndicator.hide()
                me.showError(UserMessages.errorTitle, message: UserMessages.RegaloPreview.galiciaPostError)
                return
            }
            DataManager.shared.createRegalo(userId: userId, motivo: motivo, descripcion: descripcion, closeDate: date,
                                            targetAmount: amount, perPersonAmount: perPersonAmount, regalosSugeridos: regalosSugeridos ?? [], account: accountId)
                .do(onNext: { [weak self] (regalo: Regalo) in
                    LoadingIndicator.hide()
                    self?.performSegue(withIdentifier: R.segue.regaloPreviewViewController.showRegaloSetupCompleted.identifier, sender: regalo)
                    }, onError: { [weak self] (error) in
                        LoadingIndicator.hide()
                        self?.showError(UserMessages.RegaloPreview.confirmationError)
                    }).subscribe().addDisposableTo(me.disposeBag)
            }, onError: { [weak self] error in
                LoadingIndicator.hide()
                guard let me = self else { return }
                me.showError(UserMessages.errorTitle, message: UserMessages.RegaloPreview.galiciaPostError)
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
        guard let regalo = sender as? Regalo, let code = regalo.codigo else { return }
        (segue.destination as? ShareRegaloViewController)?.code = code
    }

}

// MARK: TableView editing
extension RegaloPreviewViewController {

    @objc(tableView:canEditRowAtIndexPath:)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let section = form.sectionBy(tag: ideaSectionTag), indexPath.section == section.index && indexPath.row != section.count - 1 {
            return true
        }
        return false
    }

    @objc(tableView:editingStyleForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if let section = form.sectionBy(tag: ideaSectionTag), indexPath.section == section.index {
            return .delete
        }
        return .none
    }

    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var section = form[indexPath.section]
            section.remove(at: indexPath.row)
        }
    }

}

extension UserMessages.RegaloPreview {

    static let title = NSLocalizedString("Nuevo regalo", comment: "")
    static let addIdea = NSLocalizedString("Agregar idea", comment: "")
    static let buttonText = NSLocalizedString("Confirmar", comment: "")
    static let regaloIdeasTitle = NSLocalizedString("Ideas de regalo", comment: "")
    static let regaloIdeasHelp = NSLocalizedString("Los participantes podrán votar entre las opciones", comment: "")
    static let closeDateText = NSLocalizedString("Fecha de cierre", comment: "")
    static let perPersonText = NSLocalizedString("por persona", comment: "")
    static let amountText = NSLocalizedString("Objetivo", comment: "")
    static let confirmationError = NSLocalizedString("No se pudo dar de alta el regalo. Por favor, inténtelo más tarde", comment: "")
    static let galiciaPostError = NSLocalizedString("Hubo un error al conectarse con el Banco Galicia. Por favor, inténtelo más tarde", comment: "")
}
