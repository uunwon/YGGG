//
//  LoginViewController.swift
//  YGGG
//
//  Created by uunwon on 6/4/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

let COLLECTION_USERS = Firestore.firestore().collection("users")

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
    
    lazy var googleLoginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        let button = UIButton()
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        
        config.title = "Google로 시작하기"
        config.image = UIImage(named: "Google Logo")
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.baseForegroundColor = .black
        
        button.configuration = config
        
        button.layer.masksToBounds = true // button rounding
        button.layer.cornerRadius = 7
        
        let action = UIAction { [weak self] _ in
            self?.handleSignInButton()
        }

        button.addAction(action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var titleLabelConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            loginLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(googleLoginButton)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateLayout()
    }
    
    // MARK: - Methods
    func updateLayout() {
        NSLayoutConstraint.activate(titleLabelConstraints + descriptionLabelConstraints + googleLoginButtonConstraints)
    }
    
    // 로그인 성공 시 메인 화면으로 전환
    func moveToMain() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.moveToMain()
    }
    
    func handleSignInButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration Object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the Sign In Flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("Press the cancel Button")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                // At this point, our user is signed in
                guard let user = result?.user else { return }
                
                let data: [String: Any] = ["email": user.email as Any,
                                           "uid": user.uid,
                                           "snsRoot": "google",
                                           "userName": user.displayName as Any,
                                           "userImage": user.photoURL?.absoluteString ?? "",
                                           "userHashTag": "",
                                           "userCosmetics": [],
                                           "bookmarkList": []]
                
                COLLECTION_USERS.document(user.uid).setData(data)
                
                print("Success to Login")
                self.moveToMain()
            }
        }
        
    }
    
}
