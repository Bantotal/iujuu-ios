//
//  GenericPasswordCell.swift
//  GenericPasswordRow
//
//  Created by Diego Ernst on 9/6/16.
//  Copyright © 2016 Diego Ernst. All rights reserved.
//

import Foundation
import Eureka

open class GenericPasswordCell: Cell<String>, CellType, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var visibilityButton: UIButton?
    @IBOutlet weak var passwordStrengthView: PasswordStrengthView?
    @IBOutlet weak var hintLabel: UILabel?

    var genericPasswordRow: _GenericPasswordRow! {
        return row as? _GenericPasswordRow
    }

    open var visibilityImage: (on: UIImage?, off: UIImage?) {
        didSet {
            setVisibilityButtonImage()
        }
    }

    open var dynamicHeight = (collapsed: UITableViewAutomaticDimension, expanded: UITableViewAutomaticDimension) {
        didSet {
            let value = dynamicHeight
            height = { [weak self] in
                self?.hintLabel?.isHidden == true ? value.collapsed : value.expanded
            }
        }
    }

    public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func setup() {
        super.setup()
        dynamicHeight = (collapsed: 48, expanded: 64)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        textField.delegate = self
        selectionStyle = .none
        textField.addTarget(self, action: #selector(GenericPasswordCell.textFieldDidChange(_:)), for: .editingChanged)

        visibilityButton?.addTarget(self, action: #selector(GenericPasswordCell.togglePasswordVisibility), for: .touchUpInside)
        visibilityButton?.tintColor = .gray

        visibilityImage = (on: UIImage(named: "visibility"), off: UIImage(named: "visibility_off"))
        hintLabel?.alpha = 0
        passwordStrengthView?.setPasswordValidator(genericPasswordRow.passwordValidator)
        updatePasswordStrengthIfNeeded(animated: false)
    }

    override open func update() {
        super.update()
        textField.text = genericPasswordRow.value
        textField.placeholder = genericPasswordRow.placeholder
    }

    open func togglePasswordVisibility() {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        setVisibilityButtonImage()
        // workaround to update cursor position
        let tmpString = textField.text
        textField.text = nil
        textField.text = tmpString
    }

    fileprivate func setVisibilityButtonImage() {
        visibilityButton?.setImage(textField.isSecureTextEntry ? visibilityImage.on : visibilityImage.off, for: .normal)
    }

    open func textFieldDidChange(_ textField: UITextField) {
        genericPasswordRow.value = textField.text
        updatePasswordStrengthIfNeeded()

        formViewController()?.tableView?.beginUpdates()
        // this updates the height of the cell
        formViewController()?.tableView?.endUpdates()

        UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: { [weak self] in
            guard let me = self else { return }
            me.hintLabel?.alpha = me.hintLabel?.isHidden == true ? 0 : 1
            }, completion: nil)

        // make the cell full visible
        if let indexPath = row?.indexPath {
            UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
                self?.formViewController()?.tableView?.scrollToRow(at: indexPath, at: .none, animated: false)
            }, completion: nil)
        }
    }

    open func updatePasswordStrengthIfNeeded(animated: Bool = true) {
        guard let password = textField.text else { return }
        passwordStrengthView?.updateStrength(password: password, animated: animated)
        let hint = genericPasswordRow.passwordValidator.hintForPassword(password)
        hintLabel?.text = hint
        hintLabel?.isHidden = hint == nil || password.isEmpty
    }

    open override func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled && textField.canBecomeFirstResponder
    }

    open override func cellBecomeFirstResponder(withDirection: Direction) -> Bool {
        return textField.becomeFirstResponder()
    }

    open override func cellResignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        formViewController()?.beginEditing(of: self)
        formViewController()?.textInputDidBeginEditing(textField, cell: self)
    }

    open func textFieldDidEndEditing(_ textField: UITextField) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldReturn(textField, cell: self) ?? true
    }

}
