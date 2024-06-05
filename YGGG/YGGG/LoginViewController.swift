//
//  LoginViewController.swift
//  YGGG
//
//  Created by uunwon on 6/4/24.
//

import UIKit

class LoginViewController: UIViewController {
    let loginLabel: UILabel = {
       let label = UILabel()
        label.text = "로그인"
        label.font = .systemFont(ofSize: 35, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "소셜 로그인을 통해 간편하게 가입할 수 있습니다."
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let googleLoginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        let button = UIButton()
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        
        config.title = "Google로 시작하기"
        
        config.image = UIImage(systemName: "heart.fill")
        config.imagePadding = 6
        config.imagePlacement = .leading
        config.baseForegroundColor = .black // image in button color
        
        button.configuration = config
        
        button.layer.masksToBounds = true // button rounding
        button.layer.cornerRadius = 7
        
        button.addAction(UIAction { _ in
            // TODO: - Google Login
            print("Click Google Login")
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let appleLoginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        let button = UIButton()
        
        button.setTitle("Apple로 시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        config.image = UIImage(systemName: "apple.logo")
        config.imagePadding = 10
        config.imagePlacement = .leading
        button.configuration = config
        
        button.layer.masksToBounds = true // button rounding
        button.layer.cornerRadius = 7
        
        button.addAction(UIAction { _ in
            // TODO: - Apple Login
            print("Click Apple Login")
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var titleLabelConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            loginLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            loginLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30)
        ]
    }()
    
    private lazy var descriptionLabelConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30)
        ]
    }()
    
    private lazy var googleLoginButtonConstraints: [NSLayoutConstraint] = {
        return [
            googleLoginButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 80),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 53),
            googleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            googleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
    }()
    
    private lazy var appleLoginButtonConstraints: [NSLayoutConstraint] = {
        return [
            appleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 15),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 53),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(googleLoginButton)
        view.addSubview(appleLoginButton)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateLayout()
    }
    
    // MARK: - Methods
    func updateLayout() {
        NSLayoutConstraint.activate(titleLabelConstraints + descriptionLabelConstraints + googleLoginButtonConstraints + appleLoginButtonConstraints)
    }
}
