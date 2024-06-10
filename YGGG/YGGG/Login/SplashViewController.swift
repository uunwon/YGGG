//
//  SplashViewController.swift
//  YGGG
//
//  Created by uunwon on 6/6/24.
//

import UIKit

class SplashViewController: UIViewController {
    let splashImageVIew: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Splash Image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appPrimary
        
        view.addSubview(splashImageVIew)
        
        // TODO: - 로그인 여부 체크하기
        let isLogin = false
        if isLogin {
            // moveToMain()
        } else if !isLogin {
            moveToLogin()
        }
    }
    
    private lazy var splashImageViewConstraints: [NSLayoutConstraint] = {
        return [
            splashImageVIew.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageVIew.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }()
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateLayout()
    }
    
    // MARK: - Methods
    func updateLayout() {
        NSLayoutConstraint.activate(splashImageViewConstraints)
    }
    
    // 로그인 성공 시 메인 화면으로 전환
    func moveToMain() {
        let mainTabBarController = MainTabBarController()
        
        // SceneDelegate 에서 rootViewController 변경
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = mainTabBarController
        }
    }
    
    // 로그인 실패 시 로그인 화면으로 전환
    func moveToLogin() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: false, completion: nil)
    }
}
