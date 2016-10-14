//
//  ImageRow.swift
//  Iujuu
//
//  Created by user on 10/4/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Eureka

private struct customTags {
    static let image_tag = 1000
}

public struct ImageRowSourceTypes: OptionSet {

    public let rawValue: Int
    public var imagePickerControllerSourceTypeRawValue: Int { return self.rawValue >> 1 }

    public init(rawValue: Int) { self.rawValue = rawValue }
    init(_ sourceType: UIImagePickerControllerSourceType) { self.init(rawValue: 1 << sourceType.rawValue) }

    public static let PhotoLibrary  = ImageRowSourceTypes(.photoLibrary)
    public static let Camera  = ImageRowSourceTypes(.camera)
    public static let SavedPhotosAlbum = ImageRowSourceTypes(.savedPhotosAlbum)
    public static let All: ImageRowSourceTypes = [Camera, PhotoLibrary, SavedPhotosAlbum]

}

extension ImageRowSourceTypes {

    // MARK: Helpers

    var localizedString: String {
        switch self {
        case ImageRowSourceTypes.Camera:
            return "Take photo"
        case ImageRowSourceTypes.PhotoLibrary:
            return "Photo Library"
        case ImageRowSourceTypes.SavedPhotosAlbum:
            return "Saved Photos"
        default:
            return ""
        }
    }
}

public enum ImageClearAction {
    case no
    case yes(style: UIAlertActionStyle)
}

//MARK: - Row

open class _ImageRow<Cell: CellType>: SelectorRow<Cell, ImagePickerController> where Cell: BaseCell, Cell: TypedCellType, Cell.Value == UIImage {


    open var sourceTypes: ImageRowSourceTypes
    open internal(set) var imageURL: URL?
    open var clearAction = ImageClearAction.yes(style: .destructive)

    private var _sourceType: UIImagePickerControllerSourceType = .camera

    public required init(tag: String?) {
        sourceTypes = .All
        super.init(tag: tag)
        presentationMode = .presentModally(controllerProvider: ControllerProvider.callback { return ImagePickerController() }, onDismiss: { [weak self] vc in
            self?.select()
            vc.dismiss(animated: true)
            })
        self.displayValueFor = nil

    }

    // copy over the existing logic from the SelectorRow
    func displayImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {
        if let presentationMode = presentationMode, !isDisabled {
            if let controller = presentationMode.makeController() {
                controller.row = self
                controller.sourceType = sourceType
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: cell.formViewController()!)
            } else {
                _sourceType = sourceType
                presentationMode.present(nil, row: self, presentingController: cell.formViewController()!)
            }
        }
    }

    open override func customDidSelect() {
        guard !isDisabled else {
            super.customDidSelect()
            return
        }
        deselect()
        var availableSources: ImageRowSourceTypes = []

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let _ = availableSources.insert(.PhotoLibrary)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let _ = availableSources.insert(.Camera)
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let _ = availableSources.insert(.SavedPhotosAlbum)
        }

        sourceTypes.formIntersection(availableSources)

        if sourceTypes.isEmpty {
            super.customDidSelect()
            return
        }

        // now that we know the number of actions aren't empty
        let sourceActionSheet = UIAlertController(title: nil, message: selectorTitle, preferredStyle: .actionSheet)
        guard let tableView = cell.formViewController()?.tableView  else { fatalError() }
        if let popView = sourceActionSheet.popoverPresentationController {
            popView.sourceView = tableView
            popView.sourceRect = tableView.convert(cell.accessoryView?.frame ?? cell.contentView.frame, from: cell)
        }
        createOptionsForAlertController(sourceActionSheet)
        if case .yes(let style) = clearAction, value != nil {
            let clearPhotoOption = UIAlertAction(title: NSLocalizedString("Clear Photo", comment: ""), style: style, handler: { [weak self] _ in
                self?.value = nil
                self?.imageURL = nil
                self?.cell.height = { 60 }
                self?.cell.formViewController()?.tableView?.reloadData()
                })
            sourceActionSheet.addAction(clearPhotoOption)
        }
        // check if we have only one source type given
        if sourceActionSheet.actions.count == 1 {
            if let imagePickerSourceType = UIImagePickerControllerSourceType(rawValue: sourceTypes.imagePickerControllerSourceTypeRawValue) {
                displayImagePickerController(imagePickerSourceType)
            }
        } else {
            let cancelOption = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:nil)
            sourceActionSheet.addAction(cancelOption)

            if let presentingViewController = cell.formViewController() {
                presentingViewController.present(sourceActionSheet, animated: true)
            }
        }
    }

    open override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        guard let rowVC = segue.destination as? ImagePickerController else {
            return
        }
        rowVC.sourceType = _sourceType
    }

    open override func customUpdateCell() {
        super.customUpdateCell()
        cell.accessoryType = .none
        if let image = value {
            cell.height = { 140 }
            addImageSelected(image: image)
        } else {
            removeImage()
        }
    }

    private func addImageSelected(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: cell.frame.width - 20, height: 120))
        imageView.tag = customTags.image_tag
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        cell.bringSubview(toFront: imageView)
    }

    private func removeImage() {
        let subviews = cell.subviews
        for subView in subviews {
            if subView.tag == customTags.image_tag {
                subView.removeFromSuperview()
            }
        }
    }

    private func reloadImageCell() {
        section?.reload()
    }
}

extension _ImageRow {

    //MARK: - Helpers

    func createOptionForAlertController(_ alertController: UIAlertController, sourceType: ImageRowSourceTypes) {
        guard let pickerSourceType = UIImagePickerControllerSourceType(rawValue: sourceType.imagePickerControllerSourceTypeRawValue), sourceTypes.contains(sourceType) else { return }
        let option = UIAlertAction(title: NSLocalizedString(sourceType.localizedString, comment: ""), style: .default, handler: { [weak self] _ in
            self?.displayImagePickerController(pickerSourceType)
            })
        alertController.addAction(option)
    }

    func createOptionsForAlertController(_ alertController: UIAlertController) {
        createOptionForAlertController(alertController, sourceType: .Camera)
        createOptionForAlertController(alertController, sourceType: .PhotoLibrary)
        createOptionForAlertController(alertController, sourceType: .SavedPhotosAlbum)
    }
}

/// A selector row where the user can pick an image
public final class ImageRow: _ImageRow<PushSelectorCell<UIImage>>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
