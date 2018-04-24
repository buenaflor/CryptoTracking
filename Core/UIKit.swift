//
//  UIKit.swift
//  CryptoTracking
//
//  Created by Giancarlo on 24.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit


// MARK: - UIView Extensions

public extension UIView {
    
    /// Adds the selected view to the superview and create constraints through the closure block
    public func add(subview: UIView, createConstraints: (_ view: UIView, _ parent: UIView) -> ([NSLayoutConstraint])) {
        addSubview(subview)
        
        subview.activate(constraints: createConstraints(subview, self))
    }
    
    /// Removes specified views in the array
    public func remove(subviews: [UIView]) {
        subviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
    /// Activates the given constraints
    public func activate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Deactivates the give constraints
    public func deactivate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.deactivate(constraints)
    }
    
    /// Lays out the view to fill the superview
    public func fillToSuperview(_ subview: UIView) {
        self.add(subview: subview) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    /// Hides view with animation parameter
    public func hide(_ force: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.isHidden = force
            })
        }
        else {
            self.isHidden = force
        }
    }
}


// MARK: - ReusableView Protocol & Configurable

/// Protocol for making dataSourcing a cell easier
public protocol Configurable {
    associatedtype T
    var model: T? { get set }
    func configureWithModel(_: T)
}

/// Protocol for setting the defaultReuseIdentifier
public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    
    /// Grabs the defaultReuseIdentifier through the class name
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}


// MARK: - TableView Generics

extension UITableViewCell: ReusableView { }
extension UITableView {
    
    /// Custom Generic function for registering a TableViewCell
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(type.self, forCellReuseIdentifier: type.defaultReuseIdentifier)
    }
    
    /// Custom Generic function for dequeueing a TableViewCell
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(type.defaultReuseIdentifier)")
        }
        
        return cell
    }
}


// MARK: - Alert

extension UIViewController {
    
    /// Shows an alert message
    public func showAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


//  MARK: - Data Loading

protocol LoadingController {
    
    /// Called, when the data should load
    func loadData(force: Bool)
}




















