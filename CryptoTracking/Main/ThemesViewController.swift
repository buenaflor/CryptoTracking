//
//  ThemesViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let allThemes = Theme.all
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self)
        return tv
    }()
    
    override func viewDidLoad() {
        
        view.fillToSuperview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allThemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        
        cell.textLabel?.text = allThemes[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        switch allThemes[indexPath.row] {
        case .standard:
            ThemeManager.applyTheme(.standard)
        case .dark:
            ThemeManager.applyTheme(.dark)
        }
    }
    
}
