//
//  SettingsViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit


// MARK: - Cell Prototype

class SettingsCell: TableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel(font: .cryptoMedium, numberOfLines: 1)
        
        add(subview: self.label) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DisclosureCell: SettingsCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Protocol Structure

protocol SettingsItem {
    var cellType: SettingsCell.Type { get }
    func configure(cell: SettingsCell)
    func didSelect(settingsVC: SettingsViewController)
}

struct SettingsSection {
    var title: String?
    var items: [SettingsItem]
    var footer: String?
}


// MARK: - Cell Items

struct CurrencySettingsItem: SettingsItem {
    var cellType: SettingsCell.Type {
        return DisclosureCell.self
    }
    
    func configure(cell: SettingsCell) {
        cell.layoutSubviews()
        cell.label.text = "Default Currency"
    }
    
    func didSelect(settingsVC: SettingsViewController) {
        let vc = CurrencySettingsViewController()
        settingsVC.navigationController?.pushViewController(vc, animated: true)
    }
}

struct ThemeItem: SettingsItem {
    var cellType: SettingsCell.Type {
        return DisclosureCell.self
    }
    
    func configure(cell: SettingsCell) {
        cell.label.text = "Choose Theme"
    }
    
    func didSelect(settingsVC: SettingsViewController) {
        let vc = ThemesViewController()
        settingsVC.navigationController?.pushViewController(vc, animated: true)
    }
}

struct ResetAppItem: SettingsItem {
    var cellType: SettingsCell.Type {
        return SettingsCell.self
    }
    
    func configure(cell: SettingsCell) {
        cell.label.text = "Reset to default state"
    }
    
    func didSelect(settingsVC: SettingsViewController) {
        settingsVC.showAlert(title: "Reset", message: "App has been reset to default")
    }
}


// MARK: - SettingsView

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model = [SettingsSection]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.fillToSuperview(tableView)
        updateView()
    }
    
    func updateView() {
        let generalSection = SettingsSection(title: "General", items: [ CurrencySettingsItem(), ThemeItem() ], footer: nil)
        let resetSection = SettingsSection(title: "Reset", items: [ ResetAppItem() ], footer: nil)
        
        model = [ generalSection, resetSection ]
        
        for section in model {
            for item in section.items {
                tableView.register(item.cellType, forCellReuseIdentifier: item.cellType.defaultReuseIdentifier)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func exitItemTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MAKR: - TableView Delegates
    
    func itemAt(indexPath: IndexPath) -> SettingsItem {
        return model[indexPath.section].items[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAt(indexPath: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.cellType.defaultReuseIdentifier, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }

        item.configure(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        itemAt(indexPath: indexPath).didSelect(settingsVC: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model[section].title
    }
    
}
