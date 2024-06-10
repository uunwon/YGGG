//
//  MainTabBarController.swift
//  YGGG
//
//  Created by uunwon on 6/5/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 각 탭에 들어갈 뷰 컨트롤러 설정
        // TODO: - 각 탭에 맞는 ViewController 대입하기
        let followViewController = ViewController()
        let homeViewController = HomeViewController()
        let myViewController = ViewController()
                
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
        
        tabBar.tintColor = UIColor.appGreen // 선택한 탭 아이템 색상 설정
        
        let tabBarList = [followViewController, homeViewController, myViewController]
        viewControllers = tabBarList
    }
}
