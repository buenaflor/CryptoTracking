//
//  UILabel.swift
//  CryptoTracking
//
//  Created by Giancarlo on 25.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class Label: UILabel {
    
    init() {
        super.init(frame: .zero)
    }
    
    init(font: UIFont, numberOfLines: Int, breakMode: NSLineBreakMode? = nil) {
        super.init(frame: .zero)
        self.font = font
        self.numberOfLines = numberOfLines
        if let breakMode = breakMode { self.lineBreakMode = breakMode }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

