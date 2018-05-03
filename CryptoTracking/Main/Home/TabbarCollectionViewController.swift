//
//  TabbarCollectionViewController.swift
//  CryptoTracking
//
//  Created by Giancarlo on 03.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class TabbarCollectionViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate ,UIScrollViewDelegate {
    
    // Declare it outside of orderedVC so we can call loadData
    let mainVC = MainViewController()
    
    let tabbarView = UIView()
    
    var lastPendingViewControllerIndex = 0
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [mainVC.wrapped(), SettingsViewController().wrapped()]
    }()
    
    lazy var tabbarStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [homeButton, watchListButton])
        sv.distribution = .fillEqually
        return sv
    }()

    let homeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "cryptoTracking_triangle").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .blue
        return btn
    }()
    
    let watchListButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "cryptoTracking_eye").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            scrollView.delegate = self
        }
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        tabbarView.backgroundColor = .white
        
        view.add(subview: tabbarView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 60)
            ]}
        
        tabbarView.fillToSuperview(tabbarStackView)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
    
        return orderedViewControllers[nextIndex]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
