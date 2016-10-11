//
//  EditRegaloViewController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/6/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import RxSwift
import Opera

fileprivate let addIdeaRowTag = "addIdeaRowTag"
fileprivate let ideaSectionTag = "ideaSectionTag"
fileprivate let descripcionTag = "descripcion"
fileprivate let dateTag = "dateTag"
fileprivate let amountTag = "amountTag"
fileprivate let suggestedTag = "suggestedTag"

class EditRegaloViewController: FormViewController {

    var regalo: Regalo!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
            <<< LabelRow() {
                $0.value = regalo.motivo
                $0.title = UserMessages.EditRegalo.motivo
            }
            <<< TextRow(descripcionTag) {
                $0.title = UserMessages.EditRegalo.description
                $0.value = regalo.descripcion
            }.cellSetup({ (cell, row) in
                cell.textField.adjustsFontSizeToFitWidth = true
                cell.textField.minimumFontSize = 10
            })
            <<< DateInlineRow(dateTag) {
                $0.title = UserMessages.EditRegalo.finishDate
                $0.value = regalo.fechaDeCierre
                $0.minimumDate = Date()
            }
            <<< CurrencyIntRow(amountTag) {
                $0.title = UserMessages.EditRegalo.montoObjetivo
                $0.value = regalo.amount
            }
            <<< CurrencyIntRow(suggestedTag) {
                $0.title = UserMessages.EditRegalo.montoSugerido
                $0.value = regalo.perPerson
            }

            +++ Section() { section in
                section.tag = ideaSectionTag
            }

            <<< LabelRow() {
                $0.title = UserMessages.RegaloPreview.regaloIdeasTitle
            }
            <<< ListItemRow(addIdeaRowTag) {
                $0.title = "+"
                $0.placeholder = UserMessages.RegaloPreview.addIdea
                }.cellSetup { (cell, row) in
                    cell.titleLabel?.font = .regular(size: 18)
                    cell.textField.font = .regular(size: 18)
                    cell.bottomSeparator?.isHidden = true
            }

        for idea in regalo.regalosSugeridos {
            addItem(with: idea.regaloDescription)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        tableView?.separatorStyle = .none
    }

    func setUpNavigationBar() {
        let bar = navigationController?.navigationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: UserMessages.cancel, style: .done, target: self, action: #selector(backTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: UserMessages.save, style: .done, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem?.tintColor = .ijOrangeColor()
        title = UserMessages.EditRegalo.title
        bar?.barTintColor = .white
        bar?.tintColor = .ijGreyishBrownColor()
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

    func saveTapped() {
        tableView?.endEditing(true)
        let values = form.values()
        guard let userId = DataManager.shared.userId,
            let desc = values[descripcionTag] as? String,
            let date = values[dateTag] as? Date,
            let amount = values[amountTag] as? Int,
            let suggested = values[suggestedTag] as? Int,
            amount > 0, suggested > 0, !desc.isEmpty else {
            showError(UserMessages.EditRegalo.ValidationError)
            return
        }

        let sugerencias = form.sectionBy(tag: ideaSectionTag)?.flatMap { $0.baseValue as? String }
        var existing = Dictionary<String, Int>()
        for suggestion in regalo.regalosSugeridos { existing[suggestion.regaloDescription] = suggestion.votos }

        let regalosSugeridos = sugerencias?.map { (suggestion) -> RegaloSugerido in
            if existing.keys.contains(suggestion) {
                return RegaloSugerido(regaloDescription: suggestion, votos: existing[suggestion]!)
            }
            return RegaloSugerido(regaloDescription: suggestion, votos: 1)
        }

        LoadingIndicator.show()
        DataManager.shared.editRegalo(userId: userId, regaloId: regalo.id, descripcion: desc, closeDate: date,
                                      targetAmount: amount, perPersonAmount: suggested, regalosSugeridos: regalosSugeridos ?? [])
            .do(onNext: { [weak self] element in
                LoadingIndicator.hide()
                self?.finish()
            }, onError: { [weak self] error in
                LoadingIndicator.hide()
                if let error = error as? OperaError {
                    switch error {
                    case let .networking(_, _, response, _):
                        if response?.statusCode == Constants.Network.ValidationError {
                            self?.showError(UserMessages.EditRegalo.ValidationError)
                            return
                        } else if response == nil {
                            self?.showError(UserMessages.networkError)
                            return
                        }
                    default: break
                    }
                }
                self?.showError(UserMessages.EditRegalo.confirmationError)
        }).subscribe().addDisposableTo(disposeBag)
    }

    func backTapped() {
        finish()
    }

    private func finish() {
        dismiss(animated: true, completion: nil)
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let section = form.sectionBy(tag: ideaSectionTag), indexPath.section == section.index && indexPath.row != section.count - 1 {
            return true
        }
        return false
    }

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.section == 0 && indexPath.row != 0 {
            let separator = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
            separator.backgroundColor = UIColor.ijSeparatorGrayColor()
            cell.addSubview(separator)
        }
        return cell
    }

}
