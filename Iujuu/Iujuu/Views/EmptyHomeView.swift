//
//  EmptyHomeView.swift
//  Iujuu
//
//  Created by user on 9/27/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit

class EmptyHomeView: UIView {

    @IBOutlet weak var nuevaColectaButton: UIButton!
    @IBOutlet weak var ingresarCodigoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setButtonsStyle()
    }
    
    private func setButtonsStyle() {
        
    }
}
