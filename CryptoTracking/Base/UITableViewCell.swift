//
//  UITableViewCell.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

// Only use this class for standard/lightweight TableView Cells

class TableViewCell: UITableViewCell {
    
    let label = Label()
    
    func configureLabel(font: UIFont, numberOfLines: Int, breakMode: NSLineBreakMode? = nil) {
        label.font = font
        label.numberOfLines = numberOfLines
        if let breakMode = breakMode { label.lineBreakMode = breakMode }
    }
    
    func addLabel() {
        add(subview: label) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
            ]}
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

