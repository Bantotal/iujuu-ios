//
//  HomeViewController.swift
//  Iujuu
//
//  Created by user on 9/27/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit

class HomeViewController: XLTableViewController {

    @IBOutlet weak var balloonsImage: UIImageView!
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let empty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    private func setTableView() {
        if empty {
           setEmptyView()
        }
    }
    
    private func setEmptyView() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setUp () {
        setTitle()
        setSettingsButton()
    }
    
    private func setTitle() {
        titleLabel.font = UIFont.ijHomeTitleFont()
        titleLabel.textColor = UIColor.ijGreyishBrownColor()
    }
    
    private func setSettingsButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.settingsTapped))
        settingsIcon.addGestureRecognizer(tap)
        settingsIcon.isUserInteractionEnabled = true
    }
    
    func settingsTapped() {
        //TODO - go to settings
        print("Setting tapped")
    }
    
}
