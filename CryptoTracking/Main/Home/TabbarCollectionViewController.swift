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
    lazy var mainVC = MainViewController(pageVC: self)
    lazy var watchListVC =  WatchListViewController(pageVC: self)
    
    lazy var mainVCWrapped = mainVC.wrapped()
    lazy var watchListWrapped = watchListVC.wrapped()
    
    let tabbarView = UIView()
    
    var vcIndex = 0
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [mainVCWrapped, watchListWrapped]
    }()
    
    lazy var tabbarStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [homeButton, watchListButton])
        sv.distribution = .fillEqually
        return sv
    }()

    lazy var homeButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(homeButtonTapped(sender:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "cryptoTracking_triangle").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .blue
        return btn
    }()
    
    lazy var watchListButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(watchListButtonTapped(sender:)), for: .touchUpInside)
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
    
    @objc func watchListButtonTapped(sender: UIButton) {
        vcIndex = 1
        watchListButton.tintColor = UIColor.CryptoTracking.darkMain
        homeButton.tintColor = .lightGray
        setViewControllers([orderedViewControllers[vcIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func homeButtonTapped(sender: UIButton) {
        vcIndex = 0
        watchListButton.tintColor = .lightGray
        homeButton.tintColor = .blue
        setViewControllers([orderedViewControllers[vcIndex]], direction: .reverse, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if previousViewControllers.first != mainVCWrapped {
                print("toot")
                watchListButton.tintColor = .lightGray
                homeButton.tintColor = .blue
            }
            else {
                print("faal")
                watchListButton.tintColor = UIColor.CryptoTracking.darkMain
                homeButton.tintColor = .lightGray
            }
        }
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
