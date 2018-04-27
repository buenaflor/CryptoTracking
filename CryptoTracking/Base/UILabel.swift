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
        self.isUserInteractionEnabled = false
        if let breakMode = breakMode { self.lineBreakMode = breakMode }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextView: UITextView {
    
    init() {
        super.init(frame: .zero, textContainer: nil)
    }
    
    init(isEditable: Bool, font: UIFont? = nil) {
        super.init(frame: .zero, textContainer: nil)
        if let font = font { self.font = font }
        self.isEditable = isEditable
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


