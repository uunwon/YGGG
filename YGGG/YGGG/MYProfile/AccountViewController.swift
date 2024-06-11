//
//  AccountViewController.swift
//  YGGG
//
//  Created by Chung Wussup on 6/11/24.
//

import UIKit

class AccountViewController: UIViewController {
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "계정 관리"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var userDeleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "settingUser"), for: .normal)
        button.setTitle("회원 탈퇴", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.imagePadding = 10 // 이미지와 타이틀 간의 간격 설정
        configuration.imagePlacement = .leading // 이미지의 위치 설정
        button.configuration = configuration
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        navigationItem.title = "계정 관리"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .white
        view.addSubview(accountLabel)
        view.addSubview(userDeleteButton)
        
        NSLayoutConstraint.activate([
            accountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            accountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            userDeleteButton.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 10),
            userDeleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDeleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userDeleteButton.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        
    }
    
}
