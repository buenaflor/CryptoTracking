//
//  DatePickerController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 30.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol DatePickerControllerDelegate: class {
    func datePickerDidPick(_ datePickerController: DatePickerController)
}

class DatePickerController: UIViewController {
    
    weak var delegate: DatePickerControllerDelegate?
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        return picker
    }()
    
    lazy var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        doDatePicker()
    }
    
    func doDatePicker(){
        
        view.add(subview: toolBar) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 45)
            ]}
        
        view.add(subview: datePicker) { (v, p) in [
            v.topAnchor.constraint(equalTo: toolBar.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor)
            ]}
        // ToolBar
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        self.view.addSubview(toolBar)
        self.toolBar.isHidden = false
    }
    
    @objc private func doneButtonTapped() {
        delegate?.datePickerDidPick(self)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
