//
//  NaviView.swift
//  YGGG
//
//  Created by Chung Wussup on 6/13/24.
//

import UIKit

class CustomNaviView: UIView {
    let title: String
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "북마크"
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero) 
        setupView()
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.text = title
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
