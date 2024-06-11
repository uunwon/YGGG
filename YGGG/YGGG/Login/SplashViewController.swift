//
//  SplashViewController.swift
//  YGGG
//
//  Created by uunwon on 6/6/24.
//

import UIKit
import GoogleSignIn
import FirebaseAuth


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
        
        if let _ = Auth.auth().currentUser {
            // 로그인 여부 체크하기
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error != nil || user == nil {
                    // Show the app's signed-out state
                    print("Any Login Information")
                    self.moveToLogin()
                } else {
                    // Show the app's signed-in state
                    print("Success to Login")
                    self.moveToMain()
                }
            }
        } else {
            self.moveToLogin()
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
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.moveToMain()
    }
    
    // 로그인 실패 시 로그인 화면으로 전환
    func moveToLogin() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: false, completion: nil)
    }
}
