//
//  ImagePickerController.swift
//  Iujuu
//
//  Created by user on 10/4/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Eureka

/// Selector Controller used to pick an image
open class ImagePickerController : UIImagePickerController, TypedRowControllerType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// The row that pushed or presented this controller
    public var row: RowOf<UIImage>!

    /// A closure to be called when the controller disappears.
    public var onDismissCallback : ((UIViewController) -> ())?

    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        (row as? ImageRow)?.imageURL = info[UIImagePickerControllerReferenceURL] as? URL
        row.value = info[UIImagePickerControllerOriginalImage] as? UIImage
        onDismissCallback?(self)
    }

    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        onDismissCallback?(self)
    }
}
