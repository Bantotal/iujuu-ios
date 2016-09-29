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

    var regalos: [Regalo] = []
    var emptyView: EmptyHomeView?
    let reuseIdentifier = "regaloCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        DataManager.shared.getRegalos()
            .do(onNext: { [weak self] regalos in
                self?.emptyView?.isHidden = regalos.count != 0
                self?.regalos = Array(regalos)
                print(self?.regalos.count)
                self?.tableView.reloadData()
            }).subscribe().addDisposableTo(disposeBag)
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(R.nib.regaloCell(), forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .white
        setEmptyView()
    }

    private func setEmptyView() {
        emptyView = R.nib.emptyHomeView.firstView(owner: nil)

        emptyView?.nuevaColectaAction = {
            self.sendToCrearColecta()
        }

        emptyView?.ingresarCodigoAction = {
            self.sendToIngresarCodigo()
        }

        tableView.backgroundView = emptyView
    }

    private func sendToCrearColecta() {
        let viewController = R.storyboard.createRegalo().instantiateInitialViewController()!
        present(viewController, animated: true, completion: nil)
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
        titleLabel.font = UIFont.regular(size: 20)
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
            return regalos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RegaloCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? RegaloCell
        cell.setup(regalo: regalos[indexPath.section])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RegaloCell.rowHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
