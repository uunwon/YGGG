//
//  MainTabBarController.swift
//  YGGG
//
//  Created by uunwon on 6/5/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    let doubleTitleView = DoubleTitleView()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .appPrimary
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        setupNavigationBar()
        
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
        
        tabBar.tintColor = UIColor.yggg_green
        
        let tabBarList = [followViewController, homeViewController, myViewController]
        viewControllers = tabBarList
    }
}

extension MainTabBarController {
    func setupNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        doubleTitleView.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        doubleTitleView.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: doubleTitleView.leftButton),
            UIBarButtonItem(customView: doubleTitleView.rightButton)
        ]
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        plusButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
    }
    
    @objc func leftButtonTapped() {
        if let homeVC = self.viewControllers?.first(where: { $0 is MainViewController }) as? MainViewController {
            homeVC.leftButtonTapped()
            
            doubleTitleView.leftButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
            doubleTitleView.rightButton.titleLabel?.font = .systemFont(ofSize: 25)
            doubleTitleView.rightButton.setTitleColor(.gray, for: .normal)
            doubleTitleView.leftButton.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func rightButtonTapped() {
        if let homeVC = self.viewControllers?.first(where: { $0 is MainViewController }) as? MainViewController {
            homeVC.rightButtonTapped()
            
            doubleTitleView.leftButton.titleLabel?.font = .systemFont(ofSize: 25)
            doubleTitleView.rightButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
            doubleTitleView.leftButton.setTitleColor(.gray, for: .normal)
            doubleTitleView.rightButton.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func plusButtonTapped() {
        if let homeVC = self.viewControllers?.first(where: { $0 is MainViewController }) as? MainViewController {
            homeVC.plusButtonTapped()
        }
    }
}
