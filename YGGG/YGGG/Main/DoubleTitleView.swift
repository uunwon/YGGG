//
//  MainTabButtonViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/4/24.
//

import UIKit

class DoubleTitleView: UIView {
    let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.setTitle("홈", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.setTitle("무덤", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(leftButton)
        addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 15),
            rightButton.topAnchor.constraint(equalTo: leftButton.topAnchor)
        ])
    }
}
