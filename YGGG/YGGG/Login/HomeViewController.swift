//
//  HomeViewController.swift
//  YGGG
//
//  Created by uunwon on 6/10/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appPrimary
        
        logoutButton()
    }
    
    func logoutButton() {
        let testButton = UIButton()
        testButton.setTitle("Logout", for: .normal)
        testButton.backgroundColor = .yggg_green
        testButton.translatesAutoresizingMaskIntoConstraints = false
        
        let action = UIAction { [weak self] _ in
            self?.logout()
        }
        
        testButton.addAction(action, for: .touchUpInside)
        view.addSubview(testButton)
        
        testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func logout() {
        let firebashAuth = Auth.auth()
        do {
            try firebashAuth.signOut()
            GIDSignIn.sharedInstance.signOut()
            GIDSignIn.sharedInstance.disconnect()
            print("로가웃 완")
            self.moveToLogin()
        } catch let signOutError as NSError {
            print("Error signing 로가웃 에러 out: %@", signOutError)
        }
    }
    
    // 로그인 실패 시 로그인 화면으로 전환
    func moveToLogin() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: false, completion: nil)
    }
    
}
