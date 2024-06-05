//
//  TombViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/4/24.
//

import UIKit

class StackViewCollectionViewCell: UICollectionViewCell {
    static let name = "StackViewCollectionViewCell"
    
    lazy var stackView: UIStackView = {
        let titles = ["전체", "냉동", "냉장", "실온"]
        
        let buttons = titles.compactMap {
            let button = UIButton()
            button.setTitle($0, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            return button
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

