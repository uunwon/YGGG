//
//  MainTabBarController.swift
//  YGGG
//
//  Created by uunwon on 6/5/24.
//

import UIKit

class MainTabBarController: UITabBarController {
        
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    let customView = NaviDoubleButtonView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .yggg_orange2
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.delegate = self
        
        
        view.backgroundColor = .white
        
        let followViewController = BookmarkTableViewController()
        let homeViewController = MainViewController()
        let myViewController = MyProfileVIewController()
        
        followViewController.tabBarItem = UITabBarItem(
            title: "Follow",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        myViewController.tabBarItem = UITabBarItem(
            title: "My",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        tabBar.tintColor = .yggg_green
        tabBar.backgroundColor = .white
        let tabBarList = [followViewController, homeViewController, myViewController]
        viewControllers = tabBarList
        selectedIndex = 1
        setupNavigationBar(viewController: homeViewController)
    }
}

extension MainTabBarController {
    func setupNavigationBar(viewController: UIViewController) {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItems = nil
        
        if viewController is MainViewController {
            
            customView.delegate = self
            
            let customBarButtonItem = UIBarButtonItem(customView: customView)
            navigationItem.leftBarButtonItem = customBarButtonItem
            
            plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
            plusButton.tintColor = .black
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
        } else if viewController is BookmarkTableViewController {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: CustomNaviView(title: "북마크"))
        } else if viewController is MyProfileVIewController {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: CustomNaviView(title: "프로필"))
        }
    }
    
    @objc func plusButtonTapped() {
        if let homeVC = self.viewControllers?.first(where: { $0 is MainViewController }) as? MainViewController {
            homeVC.plusButtonTapped()
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        setupNavigationBar(viewController: viewController)
    }
}

extension MainTabBarController: CustomNavigationViewDelegate {
    private var mainViewController: MainViewController? {
        return viewControllers?.compactMap { $0 as? MainViewController }.first
    }
    
    func configureButtons(leftButtonBold: Bool) {
        customView.leftButton.titleLabel?.font = leftButtonBold ? .boldSystemFont(ofSize: 25) : .systemFont(ofSize: 25)
        customView.rightButton.titleLabel?.font = leftButtonBold ? .systemFont(ofSize: 25) : .boldSystemFont(ofSize: 25)
        customView.leftButton.setTitleColor(leftButtonBold ? .black : .gray, for: .normal)
        customView.rightButton.setTitleColor(leftButtonBold ? .gray : .black, for: .normal)
    }
    
    func leftButtonTapped() {
        configureButtons(leftButtonBold: true)
        mainViewController?.leftButtonTapped()
    }
    
    func rightButtonTapped() {
        configureButtons(leftButtonBold: false)
        mainViewController?.rightButtonTapped()
    }
}
