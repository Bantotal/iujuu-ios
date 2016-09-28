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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setEmptyView()
    }
    
    private func setEmptyView() {
        if empty {
            let emptyView = R.nib.emptyHomeView.firstView(owner: nil)
            
            emptyView?.nuevaColectaAction = {
                self.sendToCrearColecta()
            }
            
            emptyView?.ingresarCodigoAction = {
                self.sendToIngresarCodigo()
            }
            
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
    }
    
    private func sendToCrearColecta() {
        UIApplication.changeRootViewController(R.storyboard.createRegalo().instantiateInitialViewController()!)
    }
    
    private func sendToIngresarCodigo() {
        //TODO - send to ingresar codigo
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
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if empty {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
