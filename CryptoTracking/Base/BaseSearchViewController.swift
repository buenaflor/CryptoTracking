//
//  BaseSearchViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class BaseSearchViewController: BaseViewController {
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.tableFooterView = UIView()
        return tv
    }()
}
