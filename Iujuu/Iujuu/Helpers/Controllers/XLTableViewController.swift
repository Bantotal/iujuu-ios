//
//  XLTableViewController.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class XLTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var disposeBag = DisposeBag()
}
