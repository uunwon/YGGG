//
//  NaviDoubleButtonView.swift
//  YGGG
//
//  Created by Chung Wussup on 6/13/24.
//

import UIKit

protocol CustomNavigationViewDelegate: AnyObject {
    func leftButtonTapped()
    func rightButtonTapped()
}

class NaviDoubleButtonView: UIView {
    
    weak var delegate: CustomNavigationViewDelegate?
    
    let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitle("홈", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitle("만료", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    let underLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private var underLineViewLeadingConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        selectedButton = leftButton
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        selectedButton = leftButton
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [leftButton, rightButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(underLineView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            underLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underLineView.heightAnchor.constraint(equalToConstant: 1),
            leftButton.widthAnchor.constraint(equalToConstant: 44),
            rightButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // 저장할 제약조건 설정
        underLineViewLeadingConstraint = underLineView.leadingAnchor.constraint(equalTo: leftButton.leadingAnchor)
        
        
        NSLayoutConstraint.activate([
            underLineViewLeadingConstraint!,
            underLineView.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        // 초기 레이아웃 설정
        updateUnderLineView(button: leftButton)
        selectedButton = leftButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUnderLineView(button: selectedButton)
    }
    
    
    var selectedButton: UIButton
    
    private func updateUnderLineView(button: UIButton) {
        selectedButton = button
        UIView.animate(withDuration: 0.3) {
            self.underLineViewLeadingConstraint?.constant = button.frame.origin.x
            self.layoutIfNeeded()
        }
        
    }
    
    @objc private func leftButtonTapped() {
        delegate?.leftButtonTapped()
        updateUnderLineView(button: leftButton)
    }
    
    @objc private func rightButtonTapped() {
        delegate?.rightButtonTapped()
        updateUnderLineView(button: rightButton)
    }
}
